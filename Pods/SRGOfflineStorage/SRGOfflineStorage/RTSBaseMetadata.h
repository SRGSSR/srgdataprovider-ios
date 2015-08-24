//
//  RTSBaseMetadata
//  SRGOfflineStorage
//
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Realm/Realm.h>
#import "SRGMetadatasProtocols.h"

@interface RTSBaseMetadata : RLMObject <SRGBaseMetadataContainer>

// As Realm doc indicates, do not provide storage keyword (strong, assign...) in properties.
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imageURLString;
@property (nonatomic) NSString *audioChannelID;

@property (nonatomic) NSDate *expirationDate;
@property (nonatomic) NSDate *favoriteChangeDate;

@property (nonatomic) BOOL isFavorite;

+ (instancetype)metadataForContainer:(id<SRGBaseMetadataContainer>)container;
- (instancetype)initWithContainer:(id<SRGBaseMetadataContainer>)container;

- (void)udpateWithContainer:(id<SRGBaseMetadataContainer>)container;
- (BOOL)isValueEmptyForKey:(NSString *)key;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RTSMediaMetadata>
RLM_ARRAY_TYPE(RTSBaseMetadata)
