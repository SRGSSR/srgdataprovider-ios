//
//  SRGILMediaMetadata.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Realm/Realm.h>
#import "RTSMediaMetadatasProtocols.h"

@interface RTSMediaMetadata : RLMObject <RTSMediaMetadataContainer>

// As Realm doc indicates, do not provide storage keyword (strong, assign...) in properties.
@property NSString *identifier;
@property NSString *title;
@property NSString *parentTitle;
@property NSString *mediaDescription;
@property NSString *imageURLString;
@property NSString *radioShortName;

@property NSDate *publicationDate;
@property NSDate *expirationDate;
@property NSDate *favoriteChangeDate;

@property long durationInMs;
@property int viewCount;
@property BOOL isDownloadable;
@property BOOL isFavorite;

+ (RTSMediaMetadata *)mediaMetadataForContainer:(id<RTSMediaMetadataContainer>)container;
- (BOOL)isValueEmptyForKey:(NSString *)key;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RTSMediaMetadata>
RLM_ARRAY_TYPE(RTSMediaMetadata)
