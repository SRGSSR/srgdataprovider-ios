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

static void *kStorageCenterAssociatedObjectKey = &kStorageCenterAssociatedObjectKey;

@interface SRGILDataProvider (OfflineStoragePrivate)

@property(nonatomic, strong) RTSOfflineStorageCenter *storageCenter;

@end

@implementation SRGILDataProvider (OfflineStorage)

- (id<RTSMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier
{
    SRGILMedia *existingMedia = [self.identifiedMedias objectForKey:identifier];
    SRGILMediaMetadata *md = [SRGILMediaMetadata mediaMetadataForMedia:existingMedia];
    return md;
}

- (id<RTSShowMetadataContainer>)showMetadataContainerForIdentifier:(NSString *)identifier
{
    SRGILShow *existingShow = [self.identifiedShows objectForKey:identifier];
    SRGILShowMetadata *md = [SRGILShowMetadata showMetadataForShow:existingShow];
    return md;
}

- (BOOL)isMediaFlaggedAsFavorite:(NSString *)identifier
{
    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }
    id<RTSMediaMetadataContainer> md = [self.storageCenter mediaMetadataForIdentifier:identifier];
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

- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID
{
    if (!identifier) {
        DDLogError(@"No media identifier for flagAsFavorite %@", identifier);
        return;
    }

    if (!self.storageCenter) {
        self.storageCenter = [RTSOfflineStorageCenter favoritesCenterWithMetadataProvider:self];
    }

    [self.storageCenter flagAsFavorite:favorite mediaWithIdentifier:identifier audioChannelID:audioChannelID];
    
    if (!self.identifiedMedias[identifier]) {
        @weakify(self);
        [self.requestManager requestMediaOfType:SRGILMediaTypeVideo
                                 withIdentifier:identifier
                                completionBlock:^(SRGILMedia *media, NSError *error) {
                                    @strongify(self);
                                    if (!error) {
                                        self.identifiedMedias[identifier] = media;
                                        [self.storageCenter flagAsFavorite:favorite mediaWithIdentifier:identifier audioChannelID:audioChannelID];
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