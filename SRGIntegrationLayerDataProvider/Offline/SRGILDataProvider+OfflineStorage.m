//
//  SRGIntegrationLayerDataProvider_h+OfflineStorage.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider+OfflineStorage.h"
#import "SRGILDataProvider+Private.h"
#import "SRGILModel.h"
#import "SRGILList.h"
#import "SRGILMediaMetadata.h"

@interface SRGILDataProvider ()
@property(nonatomic, strong) RTSOfflineStorageCenter *storageCenter;
@end

@implementation SRGILDataProvider (OfflineStorage)

- (id<RTSMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier
{
    SRGILMedia *existingMedia = [[self identifiedMedias] objectForKey:identifier];
    SRGILMediaMetadata *md = [SRGILMediaMetadata mediaMetadataForMedia:existingMedia];
    return md;
}

- (void)saveMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error
{
    [[RTSOfflineStorageCenter favoritesSharedCenter] saveMediaMetadataWithIdentifier:identifier error:error];
}

- (void)deleteMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error
{
    [[RTSOfflineStorageCenter favoritesSharedCenter] deleteMediaMetadataWithIdentifier:identifier error:error];
}

- (void)extractLocalItemsOfType:(SRGILModelItemType)itemType onCompletion:(SRGILFetchListCompletionBlock)completionBlock
{
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *identifier in  [[RTSOfflineStorageCenter favoritesSharedCenter] storedMediaMetadataIdentifiers]) {
        SRGILMediaMetadata *md = [self mediaMetadataContainerForIdentifier:identifier];
        [items addObject:md];
    }
    SRGILList *itemsList = [[SRGILList alloc] initWithArray:items];
    completionBlock(itemsList, [SRGILMediaMetadata class], nil);
}

@end
