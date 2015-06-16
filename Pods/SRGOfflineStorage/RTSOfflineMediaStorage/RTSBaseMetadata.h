//
//  RTSBaseMetadata.h
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import <Realm/Realm.h>
#import "RTSMetadatasProtocols.h"

@interface RTSBaseMetadata : RLMObject <RTSBaseMetadataContainer>

// As Realm doc indicates, do not provide storage keyword (strong, assign...) in properties.
@property NSString *identifier;
@property NSString *title;
@property NSString *imageURLString;
@property NSString *audioChannelID;

@property NSDate *expirationDate;
@property NSDate *favoriteChangeDate;

@property BOOL isFavorite;

+ (instancetype)metadataForContainer:(id<RTSBaseMetadataContainer>)container;
- (instancetype)initWithContainer:(id<RTSBaseMetadataContainer>)container;

- (BOOL)isValueEmptyForKey:(NSString *)key;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RTSMediaMetadata>
RLM_ARRAY_TYPE(RTSBaseMetadata)
