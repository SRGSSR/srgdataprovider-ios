//
//  SRGILMediaMetadata.h
//  SRGOfflineStorage
//
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Realm/Realm.h>
#import "RTSBaseMetadata.h"
#import "SRGMetadatasProtocols.h"

@interface RTSMediaMetadata : RTSBaseMetadata <SRGMediaMetadataContainer>

@property (nonatomic) NSString *parentTitle;
@property (nonatomic) NSString *mediaDescription;

@property (nonatomic) NSDate *publicationDate;

@property (nonatomic) NSInteger type;
@property (nonatomic) long durationInMs;
@property (nonatomic) int viewCount;
@property (nonatomic) BOOL isDownloadable;

@property (nonatomic) BOOL isDownloading;
@property (nonatomic) BOOL isDownloaded;

@property (nonatomic) NSString *downloadURLString;
@property (nonatomic) NSString *localURLString;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RTSMediaMetadata>
RLM_ARRAY_TYPE(RTSMediaMetadata)
