//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelConstants.h"
#import "NSBundle+SRGILDataProvider.h"

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
        messages = @{ @(SRGILMediaBlockingReasonGeoblock) : SRGILDataProviderLocalizedString(@"For legal reasons, this content is not available in your region.", nil),
                      @(SRGILMediaBlockingReasonLegal) : SRGILDataProviderLocalizedString(@"This content is not available due to legal restrictions.", nil),
                      @(SRGILMediaBlockingReasonCommercial) : SRGILDataProviderLocalizedString(@"Commercial is being skipped. Please wait – playback will resume shortly.", nil),
                      @(SRGILMediaBlockingReasonAgeRating18) : SRGILDataProviderLocalizedString(@"To protect children under the age of 18, this content is only available between 11 p.m. and 5 a.m.", nil),
                      @(SRGILMediaBlockingReasonAgeRating12) : SRGILDataProviderLocalizedString(@"To protect children under the age of 12, this content is only available between 8 p.m. and 6 a.m.", nil),
                      @(SRGILMediaBlockingReasonStartDate) : SRGILDataProviderLocalizedString(@"This content is not yet available. Please try again later.", nil),
                      @(SRGILMediaBlockingReasonEndDate) : SRGILDataProviderLocalizedString(@"For legal reasons, this content was only available for a limited period of time.", nil) };
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
