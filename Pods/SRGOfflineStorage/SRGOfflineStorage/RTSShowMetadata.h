//
//  RTSShowMetadata.h
//  SRGOfflineStorage
//
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Realm/Realm.h>
#import "SRGMetadatasProtocols.h"
#import "RTSBaseMetadata.h"

@interface RTSShowMetadata : RTSBaseMetadata <SRGShowMetadataContainer>

@property (nonatomic) NSString *showDescription;

@end

RLM_ARRAY_TYPE(RTSShowMetadata)
