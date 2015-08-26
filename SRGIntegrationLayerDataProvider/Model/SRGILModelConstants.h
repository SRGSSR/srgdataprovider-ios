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
extern NSString * const SRGILVideoDownloadOverCellularNetworkKey;
extern NSString * const SRGILVideoDownloadHighQualityWhenAvailableKey;

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
    SRGILMediaImageUsageShowEpisode,
    SRGILMediaImageUsageLogo,
    SRGILMediaImageUsageLogoResponsive,
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
    SRGILPlaylistProtocolEnumBegin = 0,
    SRGILPlaylistProtocolHLS = SRGILPlaylistProtocolEnumBegin,
    SRGILPlaylistProtocolHDS,
    SRGILPlaylistProtocolRTMP,
    SRGILPlaylistProtocolHTTP,
    SRGILPlaylistProtocolUnknown,
    SRGILPlaylistProtocolEnumEnd,
    SRGILPlaylistProtocolEnumSize = SRGILPlaylistProtocolEnumEnd - SRGILPlaylistProtocolEnumBegin
};

typedef NS_ENUM(NSInteger, SRGILPlaylistURLQuality) {
    SRGILPlaylistURLQualityEnumBegin = 0,
    SRGILPlaylistURLQualitySD = SRGILPlaylistURLQualityEnumBegin,
    SRGILPlaylistURLQualityHD,
    SRGILPlaylistURLQualitySQ,
    SRGILPlaylistURLQualityLQ,
    SRGILPlaylistURLQualityMQ,
    SRGILPlaylistURLQualityHQ,
    SRGILPlaylistURLQualityUnknown,
    SRGILPlaylistURLQualityEnumEnd,
    SRGILPlaylistURLQualityEnumsize = SRGILPlaylistURLQualityEnumEnd - SRGILPlaylistURLQualityEnumBegin
};

typedef NS_ENUM(NSInteger, SRGILPlaylistSegmentation) {
    SRGILPlaylistSegmentationUnknown,
    SRGILPlaylistSegmentationLogical,
    SRGILPlaylistSegmentationPhysical
};

SRGILPlaylistProtocol SRGILPlayListProtocolForString(NSString *protocolString);
SRGILPlaylistURLQuality SRGILPlaylistURLQualityForString(NSString *qualityString);
SRGILPlaylistSegmentation SRGILPlaylistSegmentationForString(NSString *segmentationString);



typedef NS_ENUM(NSInteger, SRGILDownloadProtocol) {
    SRGILDownloadProtocolEnumBegin = 0,
    SRGILDownloadProtocolHTTP = SRGILDownloadProtocolEnumBegin,
    SRGILDownloadProtocolUnknown,
    SRGILDownloadProtocolEnumEnd,
    SRGILDownloadProtocolEnumSize = SRGILDownloadProtocolEnumEnd - SRGILDownloadProtocolEnumBegin
};

typedef NS_ENUM(NSInteger, SRGILDownloadURLQuality) {
    SRGILDownloadURLQualityEnumBegin = 0,
    SRGILDownloadURLQualitySD = SRGILDownloadURLQualityEnumBegin,
    SRGILDownloadURLQualityHD,
    SRGILDownloadURLQualityUnknown,
    SRGILDownloadURLQualityEnumEnd,
    SRGILDownloadURLQualityEnumsize = SRGILDownloadURLQualityEnumEnd - SRGILDownloadURLQualityEnumBegin
};

SRGILDownloadProtocol SRGILDownloadProtocolForString(NSString *protocolString);
SRGILDownloadURLQuality SRGILDownloadURLQualityForString(NSString *qualityString);



#endif
