//
//  SRGILMediaPlayerDataProvider.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILDataProvider.h"
#import "SRGILOrganisedModelDataItem.h"

#import "SRGILErrors.h"
#import "SRGILRequestsManager.h"
#import "SRGILTokenHandler.h"

#import "SRGILComScoreAnalyticsInfos.h"
#import "SRGILStreamSenseAnalyticsInfos.h"
#import "SRGILAnalyticsInfosProtocol.h"

#import "SRGILModel.h"
#import "SRGILMedia+Private.h"

#import <libextobjc/EXTScope.h>

static NSString * const comScoreKeyPathPrefix = @"SRGILComScoreAnalyticsInfos.";
static NSString * const streamSenseKeyPathPrefix = @"SRGILStreamSenseAnalyticsInfos.";
static NSString * const itemClassPrefix = @"SRGIL";

@interface SRGILDataProvider () {
    NSMutableDictionary *_identifiedMedias;
    NSMutableDictionary *_taggedItemLists;
    NSMutableDictionary *_analyticsInfos;
}
@property(nonatomic, strong) SRGILRequestsManager *requestManager;
@end

@implementation SRGILDataProvider

+ (NSString *)comScoreVirtualSite:(NSString *)businessUnit
{
    return [NSString stringWithFormat:@"%@-player-ios-v", [businessUnit lowercaseString]];
}

+ (NSString *)streamSenseVirtualSite:(NSString *)businessUnit
{
    return [NSString stringWithFormat:@"%@-v", [businessUnit lowercaseString]];
}

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit
{
    self = [super init];
    if (self) {
        _identifiedMedias = [[NSMutableDictionary alloc] init];
        _taggedItemLists = [[NSMutableDictionary alloc] init];
        _analyticsInfos = [[NSMutableDictionary alloc] init];
        _requestManager = [[SRGILRequestsManager alloc] initWithBusinessUnit:businessUnit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:)
                                                     name:RTSMediaPlayerPlaybackStateDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (NSString *)businessUnit
{
    return _requestManager.businessUnit;
}

#pragma mark - RTSMediaPlayerControllerDataSource

- (void)mediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
      contentURLForIdentifier:(NSString *)identifier
            completionHandler:(void (^)(NSURL *contentURL, NSError *error))completionHandler
{
    NSAssert(identifier, @"Missing identifier to work with.");
    SRGILMedia *existingMedia = _identifiedMedias[identifier];
    
    @weakify(self)
    
    void (^tokenBlock)(SRGILMedia *) = ^(SRGILMedia *media) {
        @strongify(self)
        NSURL *contentURL = [self contentURLForMedia:media];
        [[SRGILTokenHandler sharedHandler] requestTokenForURL:contentURL
                                    appendLogicalSegmentation:nil
                                              completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                  completionHandler(tokenizedURL, error);
                                              }];
    };
    
    if ([self contentURLForMedia:existingMedia]) {
        tokenBlock(existingMedia);
    }
    else {
        [_requestManager requestMediaOfType:SRGILMediaTypeVideo
                             withIdentifier:identifier
                            completionBlock:^(SRGILMedia *media, NSError *error) {
                                _identifiedMedias[identifier] = media;
                                [self prepareAnalyticsInfosForMedia:media];
                                tokenBlock(media);
                            }];
    }
}

- (NSURL *)contentURLForMedia:(SRGILMedia *)media
{
    if ([media isKindOfClass:[SRGILVideo class]]) {
        NSURL *contentURL = nil;
        
        BOOL takeHDVideo = [[NSUserDefaults standardUserDefaults] boolForKey:SRGILVideoUseHighQualityOverCellularNetworkKey];
        BOOL usingTrueWIFINetwork = [SRGILRequestsManager isUsingWIFI] && ![SRGILRequestsManager isUsingSwisscomWIFI];
        
        if (usingTrueWIFINetwork || takeHDVideo) {
            // We are on True WIFI (non-Swisscom) or the HD quality switch is ON.
            contentURL = (media.HDHLSURL) ? [media.HDHLSURL copy] : [media.SDHLSURL copy];
        }
        else {
            // We are not on WIFI and switch is OFF. YES, business decision: we play HD as backup if we don't have SD.
            contentURL = (media.SDHLSURL) ? [media.SDHLSURL copy] : [media.HDHLSURL copy];
        }
        return contentURL;
    }
    else if ([media isKindOfClass:[SRGILAudio class]]) {
        return media.MQHLSURL ? media.MQHLSURL : media.MQHTTPURL;
    }
    
    return nil;
}

#pragma mark - View Count

- (void)sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:(NSNotification *)notification
{
    RTSMediaPlayerController *player = [notification object];
    RTSMediaPlaybackState oldState = [notification.userInfo[RTSMediaPlayerPreviousPlaybackStateUserInfoKey] integerValue];
    RTSMediaPlaybackState newState = player.playbackState;

    if (oldState == RTSMediaPlaybackStatePreparing && newState == RTSMediaPlaybackStateReady) {
        SRGILMedia *media = _identifiedMedias[player.identifier];
        if (media) {
            NSString *typeName = nil;
            switch ([[media class] type]) {
                case SRGILMediaTypeAudio:
                    typeName = @"audio";
                    break;
                case SRGILMediaTypeVideo:
                    typeName = @"video";
                    break;
                default:
                    NSAssert(false, @"Invalid media type: %d", (int)[[media class] type]);
            }
            if (typeName) {
                [_requestManager sendViewCountUpdate:player.identifier forMediaTypeName:typeName];
            }
        }
    }
}


#pragma mark - Analytics Infos 

- (void)prepareAnalyticsInfosForMedia:(SRGILMedia *)media
{
    SRGILComScoreAnalyticsInfos *comScoreDataSource = [[SRGILComScoreAnalyticsInfos alloc] initWithMedia:media];
    SRGILStreamSenseAnalyticsInfos *streamSenseDataSource = [[SRGILStreamSenseAnalyticsInfos alloc] initWithMedia:media];
    
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:media.identifier];
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:media.identifier];
    
    _analyticsInfos[comScoreKeyPath] = comScoreDataSource;
    _analyticsInfos[streamSenseKeyPath] = streamSenseDataSource;
}

- (SRGILComScoreAnalyticsInfos *)comScoreIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:identifier];
    return _analyticsInfos[comScoreKeyPath];
}

- (SRGILStreamSenseAnalyticsInfos *)streamSenseIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:identifier];
    return _analyticsInfos[streamSenseKeyPath];
}

#pragma mark - RTSAnalyticsDataSource

- (RTSAnalyticsMediaMode)mediaModeForIdentifier:(NSString *)identifier
{
    SRGILComScoreAnalyticsInfos *ds = [self comScoreIndividualDataSourceForIdenfifier:identifier];
    return ds.mediaMode;
}

- (NSDictionary *)comScoreLabelsForAppEnteringForeground
{
    return [SRGILComScoreAnalyticsInfos globalLabelsForAppEnteringForeground];
}

- (NSDictionary *)comScoreReadyToPlayLabelsForIdentifier:(NSString *)identifier
{
    SRGILComScoreAnalyticsInfos *ds = [self comScoreIndividualDataSourceForIdenfifier:identifier];
    return [ds statusLabels];
}

- (NSDictionary *)streamSensePlaylistMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsInfos *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds playlistMetadataForBusinesUnit:self.businessUnit];
}

- (NSDictionary *)streamSenseFullLengthClipMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsInfos *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds fullLengthClipMetadata];
}

#pragma mark - Item Lists

- (void)fetchFlatListOfItemType:(enum SRGILModelItemType)itemType
                   onCompletion:(SRGILFetchListCompletionBlock)completionBlock
{
    [self fetchListOfItemType:itemType
                    organised:SRGILModelDataOrganisationTypeFlat
                   onProgress:nil
                 onCompletion:completionBlock];
}

- (void)fetchListOfItemType:(enum SRGILModelItemType)itemType
                  organised:(SRGILModelDataOrganisationType)orgType
                 onProgress:(SRGILFetchListDownloadProgressBlock)progressBlock
               onCompletion:(SRGILFetchListCompletionBlock)completionBlock
{
    id<NSCopying> tag = nil;
    NSString *path = nil;
    
    switch (itemType) {
        case SRGILModelItemTypeVideoLiveStreams:
            tag = @(itemType);
            path = @"video/livestream.json";
            break;
            
        default:
            break;
    }
    
    @weakify(self);
    
    if (tag && path) {
        DDLogWarn(@"Fetch request for item type %ld with path %@", itemType, path);
        
        [self.requestManager requestItemsWithURLPath:path
                                          onProgress:progressBlock
                                        onCompletion:^(NSDictionary *rawDictionary, NSError *error) {
                                            @strongify(self);
                                            [self extractItemsAndClassNameFromRawDictionary:rawDictionary
                                                                                     forTag:tag
                                                                           organisationType:orgType
                                                                        withCompletionBlock:completionBlock];
                                        }];
    }
    else {
        DDLogWarn(@"Inconsistent fetch request for item type %ld", itemType);
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
                _taggedItemLists[tag] = newItems;
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


@end
