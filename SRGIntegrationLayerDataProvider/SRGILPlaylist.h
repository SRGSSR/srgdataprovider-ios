//
//  SRGPlaylist.h
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 20/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

typedef NS_ENUM(NSInteger, SRGPlaylistProtocol) {
    SRGPlaylistProtocolHLS,
    SRGPlaylistProtocolHDS,
    SRGPlaylistProtocolRTMP,
    SRGPlaylistProtocolHTTP,
    SRGPlaylistProtocolUnknown
};

typedef NS_ENUM(NSInteger, SRGPlaylistURLQuality) {
    SRGPlaylistURLQualitySD,
    SRGPlaylistURLQualityHD,
    SRGPlaylistURLQualitySQ,
    SRGPlaylistURLQualityLQ,
    SRGPlaylistURLQualityMQ,
    SRGPlaylistURLQualityHQ,
    SRGPlaylistURLQualityUnknown
};

typedef NS_ENUM(NSInteger, SRGPlaylistSegmentation) {
    SRGPlaylistSegmentationUnknown,
    SRGPlaylistSegmentationLogical,
    SRGPlaylistSegmentationPhysical
};

@interface SRGILPlaylist : SRGILModelObject

@property(nonatomic, assign, readonly) SRGPlaylistProtocol protocol;
@property(nonatomic, assign, readonly) SRGPlaylistSegmentation segmentation;

- (NSURL *)URLForQuality:(SRGPlaylistURLQuality)quality;

@end
