//
//  SRGILDataProvider+OfflineStorage.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <SRGOfflineStorage/SRGOfflineStorage.h>

#import "SRGILDataProvider+OfflineStorage.h"
#import "SRGILDataProvider+Private.h"
#import "SRGILRequestsManager.h"
#import "SRGILModel.h"
#import "SRGILList.h"

#import "SRGILMediaMetadata.h"
#import "SRGILShowMetadata.h"

#import <objc/runtime.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

static void *kStorageCenterAssociatedObjectKey = &kStorageCenterAssociatedObjectKey;

@interface SRGILDataProvider (OfflineStoragePrivate)

@property(nonatomic, strong) RTSOfflineStorageCenter *storageCenter;

@end

@implementation SRGILDataProvider (OfflineStorage)

- (BOOL)isMediaFlaggedAsFavorite:(NSString *)urnString
{
    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }
    id<RTSMediaMetadataContainer> md = [self.storageCenter mediaMetadataForIdentifier:urnString];
    if (!md) { // if none is found with URN string. Try with identifier, for backward compatibility.
        md = [self.storageCenter mediaMetadataForIdentifier:[SRGILURN identifierForURNString:urnString]];
    }
    return [md isFavorite];
}

- (BOOL)isShowFlaggedAsFavorite:(NSString *)identifier
{
    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }
    id<RTSShowMetadataContainer> md = [self.storageCenter showMetadataForIdentifier:identifier];
    return [md isFavorite];
}

- (void)flagAsFavorite:(BOOL)favorite mediaWithURNString:(NSString *)urnString audioChannelID:(NSString *)audioChannelID
{
    if (!urnString) {
        DDLogError(@"No media URN string for flagAsFavorite %@", urnString);
        return;
    }

    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }
    
    id<RTSMediaMetadataContainer> md = [self.storageCenter mediaMetadataForIdentifier:[SRGILURN identifierForURNString:urnString]];
    if (md) { // If a media is stored the old fashion, delete it first.
        [self.storageCenter deleteMediaMetadatasWithIdentifier:[SRGILURN identifierForURNString:urnString]];
    }

    [self.storageCenter flagAsFavorite:favorite mediaWithIdentifier:urnString audioChannelID:audioChannelID];
    
    if (!self.identifiedMedias[urnString]) {
        // We don't have the complete associated media. hence, fetch it, and complete its metadatas.
        
        SRGILURN *urn = [SRGILURN URNWithString:urnString];
        NSAssert(urn.identifier, @"Unable build urn with identifier from string '%@'.", urnString);
        NSAssert(urn.mediaType != SRGILMediaTypeUndefined, @"Undefined media type from urn string '%@'.", urnString);
        
        @weakify(self);
        [self.requestManager requestMediaOfType:urn.mediaType
                                 withIdentifier:urn.identifier
                                completionBlock:^(SRGILMedia *media, NSError *error) {
                                    @strongify(self);
                                    if (!error) {
                                        self.identifiedMedias[urnString] = media;
                                        [self.storageCenter flagAsFavorite:favorite
                                                       mediaWithIdentifier:urnString
                                                            audioChannelID:audioChannelID];
                                    }
                                }];
    }
}

- (void)flagAsFavorite:(BOOL)favorite showWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID
{
    if (!identifier) {
        DDLogError(@"No show identifier for flagAsFavorite %@", identifier);
        return;
    }

    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }

    [self.storageCenter flagAsFavorite:favorite showWithIdentifier:identifier audioChannelID:audioChannelID];
}

- (NSArray *)flaggedAsFavoriteMediaMetadatas
{
    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }

    NSMutableArray *items = [NSMutableArray array];
    RLMResults *results = [self.storageCenter flaggedAsFavoriteMediaMetadatas];
    
    for (id<RTSMediaMetadataContainer>container in results) {
        SRGILMediaMetadata *md = [SRGILMediaMetadata metadataForContainer:container];
        if (md) {
            [items addObject:md];
        }
    }
    return [NSArray arrayWithArray:items];
}

- (NSArray *)flaggedAsFavoriteShowMetadatas
{
    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }

    NSMutableArray *items = [NSMutableArray array];
    RLMResults *results = [self.storageCenter flaggedAsFavoriteShowMetadatas];
    
    for (id<RTSShowMetadataContainer>container in results) {
        SRGILShowMetadata *md = [SRGILShowMetadata metadataForContainer:container];
        if (md) {
            [items addObject:md];
        }
    }
    return [NSArray arrayWithArray:items];
}

- (void)extractLocalItemsOfIndex:(SRGILFetchListIndex)index onCompletion:(SRGILFetchListCompletionBlock)completionBlock
{
    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }

    switch (index) {
        case SRGILFetchListMediaFavorite:
        case SRGILFetchListShowFavorite: {
            Class objectClass = (index == SRGILFetchListMediaFavorite) ? [SRGILMediaMetadata class] : [SRGILShowMetadata class];
            SEL providerSelector = (index == SRGILFetchListMediaFavorite) ? @selector(flaggedAsFavoriteMediaMetadatas) : @selector(flaggedAsFavoriteShowMetadatas);

            NSMutableArray *items = [NSMutableArray array];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *containers = [self.storageCenter performSelector:providerSelector];
#pragma clang diagnostic pop
            for (id<RTSBaseMetadataContainer> container in containers) {
                SRGILBaseMetadata *metadata = [objectClass metadataForContainer:container];
                if (metadata.title.length > 0) {
                    [items addObject:metadata];
                }
                else {
                    // TODO Fill content with video/play request
                    DDLogWarn(@"Skipping: %@ as title is empty", metadata.identifier);
                }
            }
            SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
            itemsList.tag = @(index);
            completionBlock(itemsList, [SRGILMediaMetadata class], nil);
        }
            break;
            
        default:
            NSAssert(NO, @"Invalid item type for local items fetch list index: %ld", (long)index);
    }
}


#pragma mark - RTSMetadatasProvider

- (id<RTSMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier
{
    SRGILMediaMetadata *md = nil;
    // For medias, the identifier must be the URN string
    SRGILMedia *existingMedia = [self.identifiedMedias objectForKey:identifier];
    if (existingMedia) {
        md = [SRGILMediaMetadata mediaMetadataForMedia:existingMedia];
    }
    else {
        id<RTSMediaMetadataContainer> container = [self.storageCenter mediaMetadataForIdentifier:identifier];
        md = [SRGILMediaMetadata metadataForContainer:container];
    }
    return md;
}

- (id<RTSShowMetadataContainer>)showMetadataContainerForIdentifier:(NSString *)identifier
{
    SRGILShowMetadata *md = nil;
    SRGILShow *existingShow = [self.identifiedShows objectForKey:identifier];
    if (existingShow) {
        md = [SRGILShowMetadata showMetadataForShow:existingShow];
    }
    else {
        id<RTSShowMetadataContainer> container = [self.storageCenter showMetadataForIdentifier:identifier];
        md = [SRGILShowMetadata metadataForContainer:container];
    }
    return md;
}


@end

@implementation SRGILDataProvider (OfflineStoragePrivate)

- (RTSOfflineStorageCenter *)storageCenter
{
    return objc_getAssociatedObject(self, kStorageCenterAssociatedObjectKey);
}

- (void)setStorageCenter:(RTSOfflineStorageCenter *)storageCenter
{
    objc_setAssociatedObject(self, kStorageCenterAssociatedObjectKey, storageCenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end