//
//  SRGILModelConstants.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SRGIntegrationLayerDataProvider_SRGILModelConstants_h
#define SRGIntegrationLayerDataProvider_SRGILModelConstants_h

extern NSString * const SRGILVideoUseHighQualityOverCellularNetworkKey;

typedef NS_ENUM (NSInteger, SRGILMediaType) {
    SRGILMediaTypeUndefined,
    SRGILMediaTypeVideo,
    SRGILMediaTypeAudio,
};

typedef NS_ENUM(NSInteger, SRGILMediaImageUsage) {
    SRGILMediaImageUsageUnknown,
    SRGILMediaImageUsageHeader,
    SRGILMediaImageUsagePodcast,
    SRGILMediaImageUsageWeb,
    SRGILMediaImageUsageEditorialPick,
    SRGILMediaImageUsageShowEpisode
};

SRGILMediaImageUsage SRGILMediaImageUsageFromString(NSString *input);

typedef NS_ENUM(NSInteger, SRGILMediaBlockingReason) {
    SRGILMediaBlockingReasonNone,
    SRGILMediaBlockingReasonGeoblock,
    SRGILMediaBlockingReasonLegal,
    SRGILMediaBlockingReasonCommercial,
    SRGILMediaBlockingReasonAgeRating18,
    SRGILMediaBlockingReasonAgeRating12,
    SRGILMediaBlockingReasonStartDate,
    SRGILMediaBlockingReasonEndDate
};

SRGILMediaBlockingReason SRGILMediaBlockingReasonForKey(NSString *key);
NSString *SRGILMediaBlockingReasonMessageForReason(SRGILMediaBlockingReason reason);

/*
 * Asset sub-types (can be used in SRGILVideo or SRGAsset)
 */
typedef NS_ENUM(NSInteger, SRGILAssetSubSetType) {
    SRGILAssetSubSetTypeEpisode,
    SRGILAssetSubSetTypeTrailer,
    SRGILAssetSubSetTypeLivestream,
    SRGILAssetSubSetTypeUnknown,
};

SRGILAssetSubSetType SRGILAssetSubSetTypeForString(NSString *subtypeString);

typedef NS_ENUM(NSInteger, SRGILPlaylistProtocol) {
    SRGILPlaylistProtocolHLS,
    SRGILPlaylistProtocolHDS,
    SRGILPlaylistProtocolRTMP,
    SRGILPlaylistProtocolHTTP,
    SRGILPlaylistProtocolUnknown
};

typedef NS_ENUM(NSInteger, SRGILPlaylistURLQuality) {
    SRGILPlaylistURLQualitySD,
    SRGILPlaylistURLQualityHD,
    SRGILPlaylistURLQualitySQ,
    SRGILPlaylistURLQualityLQ,
    SRGILPlaylistURLQualityMQ,
    SRGILPlaylistURLQualityHQ,
    SRGILPlaylistURLQualityUnknown
};

typedef NS_ENUM(NSInteger, SRGILPlaylistSegmentation) {
    SRGILPlaylistSegmentationUnknown,
    SRGILPlaylistSegmentationLogical,
    SRGILPlaylistSegmentationPhysical
};

SRGILPlaylistProtocol SRGILPlayListProtocolForString(NSString *protocol);
SRGILPlaylistURLQuality SRGILPlaylistURLQualityForString(NSString *quality);
SRGILPlaylistSegmentation SRGILPlaylistSegmentationForString(NSString *segmentation);

#endif
