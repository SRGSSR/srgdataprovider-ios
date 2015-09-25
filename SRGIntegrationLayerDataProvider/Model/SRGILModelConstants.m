//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelConstants.h"

NSString * const SRGILVideoUseHighQualityOverCellularNetworkKey = @"SRGILVideoUseHighQualityOverCellularNetworkKey";

SRGILMediaImageUsage SRGILMediaImageUsageFromString(NSString *input)
{
    static dispatch_once_t onceToken;
    static NSDictionary *usages;
    dispatch_once(&onceToken, ^{
        usages = @{ @"HEADER_SRF_PLAYER" : @(SRGILMediaImageUsageHeader),
                    @"PODCAST" : @(SRGILMediaImageUsagePodcast),
                    @"WEBVISUAL" : @(SRGILMediaImageUsageWeb),
                    @"EDITORIALPICK" : @(SRGILMediaImageUsageEditorialPick),
                    @"EPISODE_IMAGE" : @(SRGILMediaImageUsageShowEpisode),
                    @"LOGO" : @(SRGILMediaImageUsageLogo),
                    @"LOGO_RESPONSIVE" : @(SRGILMediaImageUsageLogoResponsive) };
    });
    NSNumber *usage = usages[input.uppercaseString];
    return usage ? [usage integerValue] : SRGILMediaImageUsageUnknown;
}

SRGILMediaBlockingReason SRGILMediaBlockingReasonForKey(NSString *key)
{
    static dispatch_once_t onceToken;
    static NSDictionary *reasons;
    dispatch_once(&onceToken, ^{
        reasons = @{ @"GEOBLOCK" : @(SRGILMediaBlockingReasonGeoblock),
                     @"LEGAL" : @(SRGILMediaBlockingReasonLegal),
                     @"COMMERCIAL" : @(SRGILMediaBlockingReasonCommercial),
                     @"AGERATING18" : @(SRGILMediaBlockingReasonAgeRating18),
                     @"AGERATING12" : @(SRGILMediaBlockingReasonAgeRating12),
                     @"STARTDATE" : @(SRGILMediaBlockingReasonStartDate),
                     @"ENDDATE" : @(SRGILMediaBlockingReasonEndDate) };
    });
    NSNumber *reason = reasons[key.uppercaseString];
    return reason ? [reason integerValue] : SRGILMediaBlockingReasonNone;
}

NSString *SRGILMediaBlockingReasonMessageForReason(SRGILMediaBlockingReason reason)
{
    static dispatch_once_t onceToken;
    static NSDictionary *messages;
    dispatch_once(&onceToken, ^{
        messages = @{ @(SRGILMediaBlockingReasonGeoblock) : NSLocalizedString(@"BLOCKED_GEOBLOCK", nil),
                      @(SRGILMediaBlockingReasonLegal) : NSLocalizedString(@"BLOCKED_LEGAL", nil),
                      @(SRGILMediaBlockingReasonCommercial) : NSLocalizedString(@"BLOCKED_COMMERCIAL", nil),
                      @(SRGILMediaBlockingReasonAgeRating18) : NSLocalizedString(@"BLOCKED_AGERATING18", nil),
                      @(SRGILMediaBlockingReasonAgeRating12) : NSLocalizedString(@"BLOCKED_AGERATING12", nil),
                      @(SRGILMediaBlockingReasonStartDate) : NSLocalizedString(@"BLOCKED_STARTDATE", nil),
                      @(SRGILMediaBlockingReasonEndDate) : NSLocalizedString(@"BLOCKED_ENDDATE", nil) };
    });
    return messages[@(reason)] ?: @"";
}

SRGILAssetSubSetType SRGILAssetSubSetTypeForString(NSString *subtypeString)
{
    static dispatch_once_t onceToken;
    static NSDictionary *subSetTypes;
    dispatch_once(&onceToken, ^{
        subSetTypes = @{ @"EPISODE" : @(SRGILAssetSubSetTypeEpisode),
                         @"TRAILER" : @(SRGILAssetSubSetTypeTrailer),
                         @"LIVESTREAM" : @(SRGILAssetSubSetTypeLivestream) };
    });
    NSNumber *subSetType = subSetTypes[subtypeString.uppercaseString];
    return subSetType ? [subSetType integerValue] : SRGILAssetSubSetTypeUnknown;
}

SRGILPlaylistProtocol SRGILPlayListProtocolForString(NSString *protocolString)
{
    static dispatch_once_t onceToken;
    static NSDictionary *protocols;
    dispatch_once(&onceToken, ^{
        protocols = @{ @"HTTP-HDS" : @(SRGILPlaylistProtocolHDS),
                       @"HTTP-HLS" : @(SRGILPlaylistProtocolHLS),
                       @"HTTP" : @(SRGILPlaylistProtocolHTTP),
                       @"RTMP" : @(SRGILPlaylistProtocolRTMP) };
    });
    NSNumber *protocol = protocols[protocolString.uppercaseString];
    return protocol ? [protocol integerValue] : SRGILPlaylistProtocolUnknown;
}

SRGILPlaylistURLQuality SRGILPlaylistURLQualityForString(NSString *qualityString)
{
    static dispatch_once_t onceToken;
    static NSDictionary *qualities;
    dispatch_once(&onceToken, ^{
        qualities = @{ @"SD" : @(SRGILPlaylistURLQualitySD),
                       @"HD" : @(SRGILPlaylistURLQualityHD),
                       @"SQ" : @(SRGILPlaylistURLQualitySQ),
                       @"LQ" : @(SRGILPlaylistURLQualityLQ),
                       @"MQ" : @(SRGILPlaylistURLQualityMQ),
                       @"HQ" : @(SRGILPlaylistURLQualityHQ) };
    });
    NSNumber *quality = qualities[qualityString.uppercaseString];
    return quality ? [quality integerValue] : SRGILPlaylistURLQualityUnknown;
}

SRGILPlaylistSegmentation SRGILPlaylistSegmentationForString(NSString *segmentationString)
{
    static dispatch_once_t onceToken;
    static NSDictionary *segmentations;
    dispatch_once(&onceToken, ^{
        segmentations = @{ @"PHYSICAL" : @(SRGILPlaylistSegmentationPhysical),
                           @"LOGICAL" : @(SRGILPlaylistSegmentationLogical) };
    });
    NSNumber *segmentation = segmentations[segmentationString.uppercaseString];
    return segmentation ? [segmentation integerValue] : SRGILPlaylistSegmentationUnknown;
}


SRGILDownloadProtocol SRGILDownloadProtocolForString(NSString *protocolString)
{
    static dispatch_once_t onceToken;
    static NSDictionary *protocols;
    dispatch_once(&onceToken, ^{
        protocols = @{ @"HTTP" : @(SRGILDownloadProtocolHTTP)};
    });
    NSNumber *protocol = protocols[protocolString.uppercaseString];
    return protocol ? [protocol integerValue] : SRGILDownloadProtocolUnknown;
}

SRGILDownloadURLQuality SRGILDownloadURLQualityForString(NSString *qualityString)
{
    static dispatch_once_t onceToken;
    static NSDictionary *qualities;
    dispatch_once(&onceToken, ^{
        qualities = @{ @"SD" : @(SRGILDownloadURLQualitySD),
                       @"HD" : @(SRGILDownloadURLQualityHD),
                       @"LQ" : @(SRGILDownloadURLQualityLQ)};
    });
    NSNumber *quality = qualities[qualityString.uppercaseString];
    return quality ? [quality integerValue] : SRGILDownloadURLQualityUnknown;
}
