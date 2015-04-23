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
#import "SRGILMediaMetadata.h"

@implementation SRGILDataProvider (OfflineStorage)

- (id<RTSMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier
{
    SRGILMedia *existingMedia = [[self identifiedMedias] objectForKey:identifier];
    SRGILMediaMetadata *md = [SRGILMediaMetadata mediaMetadataForMedia:existingMedia];
    return md;
}

@end
