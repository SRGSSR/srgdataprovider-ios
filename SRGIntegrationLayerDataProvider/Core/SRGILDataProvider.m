//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILDataProvider.h"
#import "SRGILDataProvider+Private.h"
#import "SRGILDataProviderConstants.h"
#import "SRGILURLComponents.h"

#import "SRGILModel.h"

#import "SRGILList.h"
#import "SRGILRequestsManager.h"
#import "SRGILRequestsManager+Private.h"
#import "SRGILURLComponents.h"

#import "NSBundle+SRGILDataProvider.h"

#import <libextobjc/EXTScope.h>

#if __has_include("SRGILDataProviderOfflineStorage.h")
#import "SRGILDataProviderOfflineStorage.h"
#endif

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

static NSString * const itemClassPrefix = @"SRGIL";
static NSString * const SRGConfigNoValidRequestURLPath = @"SRGConfigNoValidRequestURLPath";
static NSArray *validBusinessUnits = nil;

@interface SRGILDataProvider () {
    NSMutableDictionary *_identifiedItemLists;
    NSString *_UUID;
}
@end

@implementation SRGILDataProvider

+ (void)initialize
{
    if (self == [SRGILDataProvider class]) {
        validBusinessUnits = @[@"srf", @"rts", @"rsi", @"rtr", @"swi"];
    }
}

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit
{
    if (!businessUnit) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"You must provide a business unit value."
                                     userInfo:nil];
    }
    
    if (![validBusinessUnits containsObject:businessUnit]) {
        NSString *msg = [NSString stringWithFormat:
                         @"The provided business unit value is invalid. Must be one of %@",
                         validBusinessUnits];
        
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:msg
                                     userInfo:nil];
    }
    
    self = [super init];
    if (self) {
        _UUID = [[NSUUID UUID] UUIDString];
        _identifiedItemLists = [[NSMutableDictionary alloc] init];
        _identifiedMedias = [[NSMutableDictionary alloc] init];
        _identifiedShows = [[NSMutableDictionary alloc] init];
        _requestManager = [[SRGILRequestsManager alloc] initWithBusinessUnit:businessUnit];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithBusinessUnit:@""];
}

- (void)dealloc
{
    // Cleanup any notification registration which could have been made in subspec files
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)businessUnit
{
    return _requestManager.businessUnit;
}

- (NSUInteger)ongoingFetchCount
{
    return _requestManager.ongoingRequests.count;
}

- (NSURL *)baseURL
{
    return _requestManager.baseURL;
}

- (void)setBaseURL:(NSURL *)baseURL
{
    _requestManager.baseURL = baseURL;
}

#pragma mark - Item Lists

- (void)fetchObjectsListWithURLComponents:(nonnull SRGILURLComponents *)components
                                organised:(SRGILModelDataOrganisationType)orgType
                            progressBlock:(nullable SRGILFetchListDownloadProgressBlock)progressBlock
                          completionBlock:(nonnull SRGILFetchListCompletionBlock)completionBlock;
{
    @weakify(self);
    
    [self.requestManager requestObjectsListWithURLComponents:components
                                               progressBlock:progressBlock
                                             completionBlock:^(NSDictionary *rawDictionary, NSError *error) {
                                                 @strongify(self);
                                                 
                                                 if (error) {
                                                     completionBlock ? completionBlock(nil, Nil, error) : nil;
                                                     return;
                                                 }
                                                 
                                                 [self recordFetchDateForIndex:components.index];
                                                 [self extractItemsAndClassNameFromRawDictionary:rawDictionary
                                                                                forURLComponents:components
                                                                                organisationType:orgType
                                                                             withCompletionBlock:completionBlock];
                                             }];
}

- (void)extractItemsAndClassNameFromRawDictionary:(NSDictionary *)rawDictionary
                                 forURLComponents:(SRGILURLComponents *)components
                                 organisationType:(SRGILModelDataOrganisationType)orgType
                              withCompletionBlock:(SRGILFetchListCompletionBlock)completionBlock
{
    if ([components.serviceVersion isEqualToString:@"2.0"])
    {
        if (components.index == SRGILFetchListVideoByEvent) {
            NSMutableDictionary *mutableGlobalProperties = [NSMutableDictionary dictionaryWithDictionary:rawDictionary];
            [mutableGlobalProperties removeObjectForKey:@"mediaList"];
            NSDictionary *globalProperties = [NSDictionary dictionaryWithDictionary:mutableGlobalProperties];
            NSArray *itemsDictionaries = rawDictionary[@"mediaList"];
            
            Class itemClass = NSClassFromString([itemClassPrefix stringByAppendingString:@"Video2"]);
            
            NSArray *organisedItems = [self organiseItemsWithGlobalProperties:globalProperties
                                                              rawDictionaries:itemsDictionaries
                                                             forURLComponents:components
                                                             organisationType:SRGILModelDataOrganisationTypeFlat
                                                                   modelClass:itemClass];
            
            if (!organisedItems) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                         code:SRGILDataProviderErrorCodeInvalidData
                                                     userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                    completionBlock(nil, nil, error);
                });
            }
            else {
                DDLogInfo(@"[Info] Returning %tu organised data item for path %@", [organisedItems count], components.string);
                
                for (SRGILList *items in organisedItems) {
                    _identifiedItemLists[items.URLComponents] = items;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(items, itemClass, nil);
                    });
                }
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                     code:SRGILDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                completionBlock(nil, nil, error);
            });
            return;
        }
        
    }
    else // suppose API version 1.0
    {
        
        // As for now, we will only extract items from a dictionary that has a single key/value pair.
        if ([[rawDictionary allKeys] count] != 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                     code:SRGILDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                completionBlock(nil, nil, error);
            });
            return;
        }
        
        // The only way to distinguish an array of items with the dictionary of a single item, is to parse the main
        // dictionary and see if we can build an _array_ of the following class names. This is made necessary due to the
        // change of semantics from XML to JSON.
        NSArray *validItemClassKeys = @[@"Video", @"Show", @"AssetSet", @"Audio", @"SearchResult", @"Topic", @"Songlog", @"EventConfig"];
        
        NSString *mainKey = [[rawDictionary allKeys] lastObject];
        id mainValue = [[rawDictionary allValues] lastObject];
        if (![mainValue isKindOfClass:[NSDictionary class]]) {
            completionBlock(nil, nil, nil);
            return;
        }
        
        NSDictionary *mainDictionary = mainValue;
        
        __block NSString *className = nil;
        __block NSArray *itemsDictionaries = nil;
        NSMutableDictionary *globalProperties = [NSMutableDictionary dictionary];
        
        [mainDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (NSClassFromString([itemClassPrefix stringByAppendingString:key]) && // We have an Obj-C class to build with
                [validItemClassKeys containsObject:key] && // It is among the known class keys
                [obj isKindOfClass:[NSArray class]]) // Its value is an array of siblings.
            {
                className = key;
                itemsDictionaries = [mainDictionary objectForKey:className];
            }
            else if ([key length] > 1 && [key hasPrefix:@"@"]) {
                [globalProperties setObject:obj forKey:[key substringFromIndex:1]];
            }
        }];
        
        
        // We haven't found an array of items. The root object is probably what we are looking for.
        if (!className && NSClassFromString([itemClassPrefix stringByAppendingString:mainKey])) {
            className = mainKey;
            itemsDictionaries = @[mainDictionary];
        }
        
        if (!className) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                     code:SRGILDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                completionBlock(nil, nil, error);
            });
        }
        else {
            Class itemClass = NSClassFromString([itemClassPrefix stringByAppendingString:className]);
            
            NSArray *organisedItems = [self organiseItemsWithGlobalProperties:globalProperties
                                                              rawDictionaries:itemsDictionaries
                                                             forURLComponents:components
                                                             organisationType:orgType
                                                                   modelClass:itemClass];
            
            if (!organisedItems) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                         code:SRGILDataProviderErrorCodeInvalidData
                                                     userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                    completionBlock(nil, nil, error);
                });
            }
            else {
                DDLogInfo(@"[Info] Returning %tu organised data item for path %@", [organisedItems count], components.string);
                
                for (SRGILList *items in organisedItems) {
                    _identifiedItemLists[items.URLComponents] = items;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(items, itemClass, nil);
                    });
                }
            }
        }
    }
}

- (NSArray *)organiseItemsWithGlobalProperties:(NSDictionary *)properties
                               rawDictionaries:(NSArray *)dictionaries
                              forURLComponents:(SRGILURLComponents *)components
                              organisationType:(SRGILModelDataOrganisationType)orgType
                                    modelClass:(Class)modelClass
{
    if ([components.serviceVersion isEqualToString:@"2.0"]) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [dictionaries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id modelObject = [[modelClass alloc] initWithDictionary:obj];
            if (modelObject) {
                [items addObject:modelObject];
                
                if ([modelObject isKindOfClass:[SRGILMedia class]]) {
                    NSString *urnString = [(SRGILMedia *)modelObject urnString];
                    _identifiedMedias[urnString] = modelObject;
                }
            }
        }];
        
        SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
        itemsList.globalProperties = properties;
        itemsList.URLComponents = components;
        return @[itemsList];
    }
    else
    {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [dictionaries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id modelObject = [[modelClass alloc] initWithDictionary:obj];
        if (modelObject) {
            [items addObject:modelObject];
            
            if ([modelObject isKindOfClass:[SRGILMedia class]]) {
                NSString *urnString = [(SRGILMedia *)modelObject urnString];
                _identifiedMedias[urnString] = modelObject;
            }
            else if ([modelObject isKindOfClass:[SRGILAssetSet class]]) {
                for (SRGILAsset *asset in [(SRGILAssetSet *)modelObject assets]) {
                    SRGILMedia *media = asset.fullLengthMedia;
                    if (media.urnString) {
                        _identifiedMedias[media.urnString] = media;
                    }
                }
            }
            else if ([modelObject isKindOfClass:[SRGILShow class]]) {
                NSString *identifier = [(SRGILShow *)modelObject identifier];
                _identifiedShows[identifier] = modelObject;
            }
            // FIXME: This does not deal with the new SRGILSearchResult possible model object class yet. In particular,
            //        should those be cached as well in some _identifiedSearchResults dictionary?
        }
    }];
    
    if ([dictionaries count] == 1 || modelClass == [SRGILAssetSet class] || modelClass == [SRGILAudio class]) {
        SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
        itemsList.globalProperties = properties;
        itemsList.URLComponents = components;
        return @[itemsList];
    }
    else if (modelClass == [SRGILVideo class]) {
        NSArray *orderPositions = [items valueForKeyPath:@"@distinctUnionOfObjects.orderPosition"];
        if (orderPositions.count == items.count) {
            NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"orderPosition" ascending:YES];
            items = [[items sortedArrayUsingDescriptors:@[desc]] mutableCopy];
        }
        SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
        itemsList.globalProperties = properties;
        itemsList.URLComponents = components;
        return @[itemsList];
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
            NSArray *letterCharacterSet = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
                                            @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
            
            NSMutableDictionary *showsGroups = [NSMutableDictionary dictionary];
            
            [sortedShows enumerateObjectsUsingBlock:^(SRGILShow *show, NSUInteger idx, BOOL *stop) {
                // Extract the first letter
                NSMutableString *firstLetter = [[[show.title substringToIndex:1] uppercaseString] mutableCopy];
                if (!firstLetter) {
                    return;
                }
                
                // Remove accents / diacritics
                CFStringTransform((__bridge CFMutableStringRef)firstLetter, NULL, kCFStringTransformStripCombiningMarks, NO);
                
                // Put non alphanumeric characters in a common # section
                unichar firstChar = [firstLetter characterAtIndex:0];
                NSString *firstCharKey = [NSString stringWithCharacters:&firstChar length:1];
                if (![letterCharacterSet containsObject:firstCharKey]) {
                    firstCharKey = @"#";
                }
                
                NSMutableArray *showsForLetter = showsGroups[firstCharKey];
                if (!showsForLetter) {
                    showsForLetter = [NSMutableArray array];
                    showsGroups[firstCharKey] = showsForLetter;
                }
                [showsForLetter addObject:show];
            }];
            
            NSMutableArray *splittedShows = [NSMutableArray array];
            NSArray *sortedShowsGroupsKeys = [[showsGroups allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            
            [sortedShowsGroupsKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES comparator:^NSComparisonResult(NSString *title1, NSString *title2) {
                    return [title1 localizedCaseInsensitiveCompare:title2];
                }];
                NSArray *sortedShows = [showsGroups[key] sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                NSMutableDictionary *extendedProperties = [properties mutableCopy];
                extendedProperties[@"tag"] = key;
                
                SRGILList *items = [[SRGILList alloc] initWithArray:sortedShows];
                items.globalProperties = [extendedProperties copy];
                items.URLComponents = components;
                
                [splittedShows addObject:items];
            }];
            
            return [NSArray arrayWithArray:splittedShows];
        }
        else {
            SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
            itemsList.globalProperties = properties;
            itemsList.URLComponents = components;
            return @[itemsList];
        }
    }
    else if (modelClass == SRGILSearchResult.class || modelClass == SRGILTopic.class || modelClass == SRGILSonglog.class || modelClass == SRGILEventConfig.class) {
        // Did not include in first case, because we'll have to deal with different type of search results (video, audio, shows).
        // We only process videos at the moment
        SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
        itemsList.globalProperties = properties;
        itemsList.URLComponents = components;
        return @[itemsList];
    }
    else {
        return nil;
    }
    }
}

#pragma mark - Fetch Dates

- (NSString *)fetchKeyForIndex:(enum SRGILFetchListIndex)index
{
    return [_UUID stringByAppendingFormat:@"-%@-FetchListIndex-%ld", self.businessUnit, (long)index];
}

- (NSDate *)fetchDateForIndex:(enum SRGILFetchListIndex)index
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[self fetchKeyForIndex:index]]) {
        NSInteger seconds = [[NSUserDefaults standardUserDefaults] integerForKey:[self fetchKeyForIndex:index]];
        return [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    }
    return nil;
}

- (NSDate *)lastFetchDateForIndexes:(NSArray *)indexes
{
    __block NSInteger seconds = 0;
    [indexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger index = ([obj isKindOfClass:[SRGILURLComponents class]]) ? [obj index] : [obj integerValue];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[self fetchKeyForIndex:index]]) {
            NSInteger newSeconds = [[NSUserDefaults standardUserDefaults] integerForKey:[self fetchKeyForIndex:index]];
            if (newSeconds > seconds) {
                seconds = newSeconds;
            }
        }
    }];
    return [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
}

- (void)recordFetchDateForIndex:(enum SRGILFetchListIndex)index
{
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSinceReferenceDate]
                                               forKey:[self fetchKeyForIndex:index]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Fetch Medias or Shows

- (id)fetchMediaWithURN:(nonnull SRGILURN *)urn completionBlock:(nonnull SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSAssert(urn.identifier.length != 0 && urn.mediaType != SRGILMediaTypeUndefined, @"The media must be valid");
    
    SRGILFetchObjectCompletionBlock wrappedCompletionBlock = ^(SRGILMedia *media, NSError *error) {
        if (error) {
            completionBlock(nil, error);
        }
        else {
            completionBlock(media, nil);
        }
    };
    
    return [self.requestManager requestMediaWithURN:urn completionBlock:wrappedCompletionBlock];
}

- (id)fetchLiveMetaInfosWithChannelID:(nonnull NSString *)channelID livestreamID:(NSString *)livestreamID completionBlock:(nonnull SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(channelID);
    NSParameterAssert(completionBlock);
    
    return [self.requestManager requestLiveMetaInfosWithChannelID:channelID livestreamID:livestreamID completionBlock:completionBlock];
}

- (id)fetchShowWithIdentifier:(NSString *)identifier completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(identifier);
    NSParameterAssert(completionBlock);
        
    SRGILFetchObjectCompletionBlock wrappedCompletionBlock = ^(SRGILShow *show, NSError *error) {
        if (error) {
            completionBlock(nil, error);
        }
        else {
            completionBlock(show, nil);
        }
    };
    
    return [self.requestManager requestShowWithIdentifier:identifier completionBlock:wrappedCompletionBlock];
}

- (void)cancelRequest:(id)request
{
    [self.requestManager cancelRequest:request];
}

#pragma mark - Data Accessors

- (SRGILList *)objectsListForURLComponents:(SRGILURLComponents *)components
{
    NSParameterAssert(components);
    return _identifiedItemLists[components];
}

- (nullable SRGILMedia *)mediaForURN:(nonnull SRGILURN *)urn
{
    NSParameterAssert(urn);
    if (!urn) {
        return nil;
    }
    return _identifiedMedias[urn.URNString];
}

- (SRGILShow *)showForIdentifier:(NSString *)identifier;
{
    NSParameterAssert(identifier);
    if (!identifier) {
        return nil;
    }
    return _identifiedShows[identifier];
}

#pragma mark - Network

+ (BOOL)isUsingWIFI
{
    return [SRGILRequestsManager isUsingWIFI];
}

+ (NSString *)WIFISSID
{
    return [SRGILRequestsManager WIFISSID];
}

+ (BOOL)isUsingSwisscomWIFI
{
    return [SRGILRequestsManager isUsingSwisscomWIFI];
}

@end
