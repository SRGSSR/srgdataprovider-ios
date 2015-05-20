//
//  SRGILDataProvider.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILDataProvider.h"
#import "SRGILDataProvider+Private.h"
#import "SRGILOrganisedModelDataItem.h"

#import "SRGILErrors.h"
#import "SRGILRequestsManager.h"

#import "SRGILDataProvider+Private.h"
#import "SRGILModel.h"
#import "SRGILMedia+Private.h"

#import <libextobjc/EXTScope.h>

#if __has_include("SRGILDataProviderOfflineStorage.h")
#import "SRGILDataProviderOfflineStorage.h"
#endif

static NSString * const itemClassPrefix = @"SRGIL";
static NSString * const SRGConfigNoValidRequestURLPath = @"SRGConfigNoValidRequestURLPath";

@interface SRGILDataProvider () {
    NSMutableDictionary *_taggedItemLists;
    NSMutableDictionary *_typedFetchPaths;
    NSMutableSet *_ongoingFetchIndices;
}
@end

@implementation SRGILDataProvider

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit
{
    self = [super init];
    if (self) {
        _identifiedMedias = [[NSMutableDictionary alloc] init];
        _identifiedShows = [[NSMutableDictionary alloc] init];
        _taggedItemLists = [[NSMutableDictionary alloc] init];
        _typedFetchPaths = [[NSMutableDictionary alloc] init];
        _requestManager = [[SRGILRequestsManager alloc] initWithBusinessUnit:businessUnit];
        _ongoingFetchIndices = [[NSMutableSet alloc] init];        
    }
    return self;
}

- (void)dealloc
{
    if ([self respondsToSelector:@selector(cleanup)]) {
        [self cleanup];
    }
}

- (NSString *)businessUnit
{
    return _requestManager.businessUnit;
}

- (NSUInteger)ongoingFetchCount;
{
    return _ongoingFetchIndices.count;
}

#pragma mark - Item Lists

- (BOOL)isFetchPathValidForIndex:(enum SRGILFetchListIndex)index
{
    return (_typedFetchPaths[@(index)] != SRGConfigNoValidRequestURLPath);
}

- (void)resetFetchPathForIndex:(enum SRGILFetchListIndex)index
{
    [_typedFetchPaths removeObjectForKey:@(index)];
}

- (void)fetchFlatListOfIndex:(enum SRGILFetchListIndex)index
                onCompletion:(SRGILFetchListCompletionBlock)completionBlock
{
    [self fetchListOfIndex:index
          withPathArgument:nil
                 organised:SRGILModelDataOrganisationTypeFlat
                onProgress:nil
              onCompletion:completionBlock];
}

- (void)fetchListOfIndex:(enum SRGILFetchListIndex)index
        withPathArgument:(id)arg
               organised:(SRGILModelDataOrganisationType)orgType
              onProgress:(SRGILFetchListDownloadProgressBlock)progressBlock
            onCompletion:(SRGILFetchListCompletionBlock)completionBlock
{
    NSAssert(completionBlock, @"Requiring a completion block");
    
    id<NSCopying> tag = @(index);
    NSString *remoteURLPath = SRGConfigNoValidRequestURLPath;
    
    switch (index) {
        case SRGILFetchListVideoLiveStreams:
            remoteURLPath = @"video/livestream.json";
            break;
            
        case SRGILFetchListVideoEditorialPicks:
            remoteURLPath = @"video/editorialPlayerPicks.json?pageSize=20";
            break;
            
        case SRGILFetchListVideoMostRecent:
            remoteURLPath = @"video/editorialPlayerLatest.json?pageSize=20";
            break;
            
        case SRGILFetchListVideoMostSeen:
            remoteURLPath = @"video/mostClicked.json?pageSize=20&period=24";
            break;
            
        case SRGILFetchListVideoShowsAZ:
            remoteURLPath = @"tv/assetGroup/editorialPlayerAlphabetical.json";
            break;
            
        case SRGILFetchListVideoShowsAZDetail:
        case SRGILFetchListAudioShowsAZDetail: {
            if ([arg isKindOfClass:[NSString class]]) {
                remoteURLPath = [NSString stringWithFormat:@"assetSet/listByAssetGroup/%@.json?pageSize=20", arg];
            }
            else if ([arg isKindOfClass:[NSDictionary class]]) {
                remoteURLPath = _typedFetchPaths[@(index)];
                NSRange r = [remoteURLPath rangeOfString:@"?"];
                NSAssert(r.location != NSNotFound, @"Missing URL arguments list starting character?");
                
                if (r.location != NSNotFound) {
                    remoteURLPath = [remoteURLPath substringToIndex:r.location+1];
                    
                    NSDictionary *properties = (NSDictionary *)arg;
                    NSInteger currentPageNumber = [[properties objectForKey:@"pageNumber"] integerValue];
                    NSInteger currentPageSize = [[properties objectForKey:@"pageSize"] integerValue];
                    NSInteger totalItemsCount = [[properties objectForKey:@"total"] integerValue];
                    
                    NSInteger expectedNewMax = (currentPageNumber+1)*currentPageSize;
                    BOOL hasReachedEnd = (expectedNewMax - totalItemsCount >= currentPageSize);
                    
                    if (!hasReachedEnd) {
                        remoteURLPath = [remoteURLPath stringByAppendingFormat:@"pageSize=%ld&pageNumber=%ld",
                                         (long)currentPageSize, (long)currentPageNumber+1];
                    }
                    else {
                        remoteURLPath = SRGConfigNoValidRequestURLPath;
                    }
                }
            }
            
        }
            break;
            
        case SRGILFetchListVideoShowsByDate: {
            NSDate *date = (arg && [arg isKindOfClass:[NSDate class]]) ? (NSDate *)arg : [NSDate date];
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
            remoteURLPath = [NSString stringWithFormat:@"video/episodesByDate.json?day=%4li-%02li-%02li",
                             (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
        }
            break;
            
        case SRGILFetchListMediaFavorite:
        case SRGILFetchListShowFavorite: {
#if __has_include("SRGILDataProviderOfflineStorage.h")
            if (progressBlock) {
                progressBlock(DOWNLOAD_PROGRESS_DONE);
            }
            // This little trick is necessary to avoid some troubles updating a collection view too quickly,
            // in the same run loop. By scheduling it for the next loop, it "looks" more like a network fetch.
            [[NSOperationQueue currentQueue] addOperationWithBlock:^{
                [self extractLocalItemsOfIndex:index onCompletion:completionBlock];
            }];
            return;
#endif
        }
            break;
            
            
        case SRGILFetchListAudioLiveStreams: {
            if ([arg isKindOfClass:[NSString class]]) {
                remoteURLPath = [NSString stringWithFormat:@"audio/play/%@.json", arg];
            }
            else {
                DDLogWarn(@"Invalid arg for SRGILFetchListAudioLiveStreams: %@", arg);
            }
        }
            break;
            
        case SRGILFetchListAudioMostRecent: {
            if ([arg isKindOfClass:[NSString class]]) {
                remoteURLPath = [NSString stringWithFormat:@"audio/latestEpisodesByChannel/%@.json?pageSize=20", arg];
            }
            else {
                DDLogWarn(@"Invalid arg for SRGILFetchListAudioMostRecent: %@", arg);
            }
        }
            break;
            
        case SRGILFetchListAudioMostListened: {
            if ([arg isKindOfClass:[NSString class]]) {
                remoteURLPath = [NSString stringWithFormat:@"audio/mostClickedByChannel/%@.json?pageSize=20", arg];
            }
            else {
                DDLogWarn(@"Invalid arg for SRGILFetchListAudioMostListened: %@", arg);
            }
        }
            break;
            
        case SRGILFetchListAudioShowsAZ: {
            if ([arg isKindOfClass:[NSString class]]) {
                remoteURLPath = [NSString stringWithFormat:@"radio/assetGroup/editorialPlayerAlphabeticalByChannel/%@.json", arg];
            }
            else {
                DDLogWarn(@"Invalid arg for SRGILFetchListAudioShowsAZ: %@", arg);
            }
        }
            break;
            
        default:
            break;
    }
    
    _typedFetchPaths[@(index)] = [remoteURLPath copy];
    
    if (remoteURLPath && remoteURLPath != SRGConfigNoValidRequestURLPath) {
        DDLogWarn(@"Fetch request for item type %ld with path %@", (long)index, remoteURLPath);
        
        @weakify(self);
        [_ongoingFetchIndices addObject:@(index)];
        [self.requestManager requestItemsWithURLPath:remoteURLPath
                                          onProgress:progressBlock
                                        onCompletion:^(NSDictionary *rawDictionary, NSError *error) {
                                            @strongify(self);
                                            [_ongoingFetchIndices removeObject:@(index)];
                                            [self extractItemsAndClassNameFromRawDictionary:rawDictionary
                                                                                     forTag:tag
                                                                           organisationType:orgType
                                                                        withCompletionBlock:completionBlock];
                                        }];
    }
    else {
        DDLogWarn(@"Inconsistent fetch request for item type %ld", (long)index);
    }
}

- (void)extractItemsAndClassNameFromRawDictionary:(NSDictionary *)rawDictionary
                                           forTag:(id<NSCopying>)tag
                                 organisationType:(SRGILModelDataOrganisationType)orgType
                              withCompletionBlock:(SRGILFetchListCompletionBlock)completionBlock
{
    if ([[rawDictionary allKeys] count] != 1) {
        // As for now, we will only extract items from a dictionary that has a single key/value pair.
        [self sendUserFacingErrorForTag:tag withTechError:nil completionBlock:completionBlock];
        return;
    }
    
    // The only way to distinguish an array of items with the dictionary of a single item, is to parse the main
    // dictionary and see if we can build an _array_ of the following class names. This is made necessary due to the
    // change of semantics from XML to JSON.
    NSArray *validItemClassKeys = @[@"Video", @"Show", @"AssetSet", @"Audio"];
    
    NSString *mainKey = [[rawDictionary allKeys] lastObject];
    NSDictionary *mainValue = [[rawDictionary allValues] lastObject];
    
    __block NSString *className = nil;
    __block NSArray *itemsDictionaries = nil;
    NSMutableDictionary *globalProperties = [NSMutableDictionary dictionary];
    
    [mainValue enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if (NSClassFromString([itemClassPrefix stringByAppendingString:key]) && // We have an Obj-C class to build with
            [validItemClassKeys containsObject:key] && // It is among the known class keys
            [obj isKindOfClass:[NSArray class]]) // Its value is an array of siblings.
        {
            className = key;
            itemsDictionaries = [mainValue objectForKey:className];
        }
        else if ([key length] > 1 && [key hasPrefix:@"@"]) {
            [globalProperties setObject:obj forKey:[key substringFromIndex:1]];
        }
    }];
    
    
    // We haven't found an array of items. The root object is probably what we are looking for.
    if (!className && NSClassFromString([itemClassPrefix stringByAppendingString:mainKey])) {
        className = mainKey;
        itemsDictionaries = @[mainValue];
    }
    
    if (!className) {
        [self sendUserFacingErrorForTag:tag withTechError:nil completionBlock:completionBlock];
    }
    else {
        Class itemClass = NSClassFromString([itemClassPrefix stringByAppendingString:className]);
        
        NSError *error = nil;
        NSArray *organisedItems = [self organiseItemsWithGlobalProperties:globalProperties
                                                          rawDictionaries:itemsDictionaries
                                                                   forTag:tag
                                                         organisationType:orgType
                                                               modelClass:itemClass
                                                                    error:&error];
        
        if (error) {
            [self sendUserFacingErrorForTag:tag withTechError:error completionBlock:completionBlock];
        }
        else {
            DDLogInfo(@"[Info] Returning %tu organised data item for tag %@", [organisedItems count], tag);
            
            for (SRGILOrganisedModelDataItem *dataItem in organisedItems) {
                SRGILList *newItems = dataItem.items;
                _taggedItemLists[newItems.tag] = newItems;
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(newItems, itemClass, nil);
                });
            }
        }
    }
}

- (NSArray *)organiseItemsWithGlobalProperties:(NSDictionary *)properties
                               rawDictionaries:(NSArray *)dictionaries
                                        forTag:(id<NSCopying>)tag
                              organisationType:(SRGILModelDataOrganisationType)orgType
                                    modelClass:(Class)modelClass
                                         error:(NSError * __autoreleasing *)error;
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [dictionaries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id modelObject = [[modelClass alloc] initWithDictionary:obj];
        if (modelObject) {
            [items addObject:modelObject];
            
            if ([modelObject isKindOfClass:[SRGILMedia class]]) {
                NSString *identifier = [(SRGILMedia *)modelObject identifier];
                _identifiedMedias[identifier] = modelObject;
            }
            if ([modelObject isKindOfClass:[SRGILShow class]]) {
                NSString *identifier = [(SRGILShow *)modelObject identifier];
                _identifiedShows[identifier] = modelObject;
            }
        }
    }];
    
    if ([dictionaries count] == 1 || modelClass == [SRGILAssetSet class] || modelClass == [SRGILAudio class]) {
        return @[[SRGILOrganisedModelDataItem dataItemForTag:tag withItems:items class:modelClass properties:properties]];
    }
    else if (modelClass == [SRGILVideo class]) {
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
        SRGILOrganisedModelDataItem *dataItem = [SRGILOrganisedModelDataItem dataItemForTag:tag
                                                                                  withItems:[items sortedArrayUsingDescriptors:@[desc]]
                                                                                      class:modelClass
                                                                                 properties:properties];
        return @[dataItem];
    }
    else if (modelClass == [SRGILShow class]) {
        if (orgType == SRGILModelDataOrganisationTypeAlphabetical) {
            // In order to produce sections in the collection view, we split the list of Shows according to their
            // alphabetical order. Hence numbers and letters become the new section tags that will then be used used
            // to build the collection view headers.
            
            NSComparator comparator = ^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)obj1 compare:(NSString *)obj2
                                         options:NSCaseInsensitiveSearch
                                           range:NSMakeRange(0, ((NSString *)obj1).length)
                                          locale:[NSLocale currentLocale]];
            };
            
            NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES comparator:comparator];
            NSArray *sortedShows = [items sortedArrayUsingDescriptors:@[desc]];
            
            NSArray *numberStrings = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
            static NSString *digitKey = @"0-9";
            __block NSString *currentKey = digitKey;
            
            NSMutableDictionary *showsGroups = [NSMutableDictionary dictionary];
            showsGroups[currentKey] = [NSMutableArray array];
            
            [sortedShows enumerateObjectsUsingBlock:^(SRGILShow *show, NSUInteger idx, BOOL *stop) {
                NSString *firstLetter = [[show.title substringToIndex:1] uppercaseString];
                if (![numberStrings containsObject:firstLetter] && ![currentKey isEqualToString:firstLetter]) {
                    currentKey = firstLetter;
                    showsGroups[currentKey] = [NSMutableArray array];
                }
                [showsGroups[currentKey] addObject:show];
            }];
            
            NSMutableArray *splittedShows = [NSMutableArray array];
            NSArray *sortedShowsGroupsKeys = [[showsGroups allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            
            [sortedShowsGroupsKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                SRGILOrganisedModelDataItem *dataItem = [SRGILOrganisedModelDataItem dataItemForTag:key
                                                                                          withItems:showsGroups[key]
                                                                                              class:modelClass
                                                                                         properties:properties];
                [splittedShows addObject:dataItem];
            }];
            
            return [NSArray arrayWithArray:splittedShows];
        }
        else {
            return @[[SRGILOrganisedModelDataItem dataItemForTag:tag withItems:items class:modelClass properties:properties]];
        }
    }
    else {
        if (error) {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"INVALID_DATA", nil)];
            *error = [NSError errorWithDomain:SRGILErrorDomain
                                         code:SRGILErrorCodeInvalidData
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
    }
    
    return nil;
}

- (void)sendUserFacingErrorForTag:(id<NSCopying>)tag
                    withTechError:(NSError *)error
                  completionBlock:(SRGILFetchListCompletionBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"INVALID_DATA_FOR_CATEGORY", nil), tag];
        NSError *newError = SRGILCreateUserFacingError(reason, error, SRGILErrorCodeInvalidData);
        completionBlock(nil, nil, newError);
    });
}

#pragma mark - Download Dates

- (NSDate *)downloadDateForKey:(NSString *)key
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        NSInteger seconds = [[NSUserDefaults standardUserDefaults] integerForKey:key];
        return [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    }
    return [NSDate dateWithTimeIntervalSinceReferenceDate:0.0];
}

- (void)refreshDownloadDateForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSinceReferenceDate] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
