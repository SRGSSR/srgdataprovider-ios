//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#ifndef SRGIntegrationLayerDataProvider_SRGILModelConstants_h
#define SRGIntegrationLayerDataProvider_SRGILModelConstants_h

extern NSString * const SRGILVideoUseHighQualityOverCellularNetworkKey;

typedef NS_ENUM (NSInteger, SRGILMediaType) {
    SRGILMediaTypeUndefined,
    SRGILMediaTypeVideo,
    SRGILMediaTypeAudio,
    SRGILMediaTypeVideoSet,
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
    SRGILAssetSubSetTypeScheduledLivestream,
    SRGILAssetSubSetTypeUnknown,
};

SRGILAssetSubSetType SRGILAssetSubSetTypeForString(NSString *subtypeString);

typedef NS_ENUM(NSInteger, SRGILPlaylistProtocol) {
    SRGILPlaylistProtocolEnumBegin = 0,
    SRGILPlaylistProtocolHLS = SRGILPlaylistProtocolEnumBegin,
    SRGILPlaylistProtocolHDS,
    SRGILPlaylistProtocolRTMP,
    SRGILPlaylistProtocolHTTP,
    SRGILPlaylistProtocolHLSDVR,
    SRGILPlaylistProtocolHDSDVR,
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
    SRGILDownloadURLQualityLQ,
    SRGILDownloadURLQualityUnknown,
    SRGILDownloadURLQualityEnumEnd,
    SRGILDownloadURLQualityEnumsize = SRGILDownloadURLQualityEnumEnd - SRGILDownloadURLQualityEnumBegin
};

SRGILDownloadProtocol SRGILDownloadProtocolForString(NSString *protocolString);
SRGILDownloadURLQuality SRGILDownloadURLQualityForString(NSString *qualityString);


typedef NS_ENUM(NSInteger, SRGILMediaTrendContributor) {
    SRGILMediaTrendContributorUnknown,
    SRGILMediaTrendContributorUser,
    SRGILMediaTrendContributorEditor,
};

#endif
