//
//  SRGILMediaMetadata.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSOfflineMediaStorage/RTSOfflineMediaStorage.h>

@class SRGILMedia;

@interface SRGILMediaMetadata : NSObject <RTSMediaMetadataContainer>

+ (SRGILMediaMetadata *)mediaMetadataForMedia:(SRGILMedia *)media;
+ (SRGILMediaMetadata *)mediaMetadataForContainer:(id<RTSMediaMetadataContainer>)container;

@end
