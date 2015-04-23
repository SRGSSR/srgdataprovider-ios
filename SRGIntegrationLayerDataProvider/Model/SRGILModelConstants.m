//
//  SRGILModelConstants.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILModelConstants.h"

NSString * const SRGILVideoUseHighQualityOverCellularNetworkKey = @"SRGILVideoUseHighQualityOverCellularNetworkKey";

SRGILMediaImageUsage SRGILMediaImageUsageFromString(NSString *input)
{
    SRGILMediaImageUsage usage = SRGILMediaImageUsageUnknown;
    if ([@"HEADER_SRF_PLAYER" isEqualToString:input]) {
        usage = SRGILMediaImageUsageHeader;
    }
    else if ([@"PODCAST" isEqualToString:input]) {
        usage = SRGILMediaImageUsagePodcast;
    }
    else if ([@"WEBVISUAL" isEqualToString:input]) {
        usage = SRGILMediaImageUsageWeb;
    }
    else if ([@"EDITORIALPICK" isEqualToString:input]) {
        usage = SRGILMediaImageUsageEditorialPick;
    }
    else if ([@"EPISODE_IMAGE" isEqualToString:input]) {
        usage = SRGILMediaImageUsageShowEpisode;
    }
    return usage;
}

NSString * const SRGILMediaBlockingReasonKeyNone           = @"NONE";
NSString * const SRGILMediaBlockingReasonKeyGeoblock       = @"GEOBLOCK";
NSString * const SRGILMediaBlockingReasonKeyLegal          = @"LEGAL";
NSString * const SRGILMediaBlockingReasonKeyCommercial     = @"COMMERCIAL";
NSString * const SRGILMediaBlockingReasonKeyAgeRating18    = @"AGERATING18";
NSString * const SRGILMediaBlockingReasonKeyAgeRating12    = @"AGERATING12";
NSString * const SRGILMediaBlockingReasonKeyStartDate      = @"STARTDATE";
NSString * const SRGILMediaBlockingReasonKeyEndDate        = @"ENDDATE";

SRGILMediaBlockingReason SRGILMediaBlockingReasonForKey(NSString *key)
{
    if ([SRGILMediaBlockingReasonKeyGeoblock isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonGeoblock;
    }
    else if ([SRGILMediaBlockingReasonKeyLegal isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonLegal;
    }
    else if ([SRGILMediaBlockingReasonKeyCommercial isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonCommercial;
    }
    else if ([SRGILMediaBlockingReasonKeyAgeRating18 isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonAgeRating18;
    }
    else if ([SRGILMediaBlockingReasonKeyAgeRating12 isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonAgeRating12;
    }
    else if ([SRGILMediaBlockingReasonKeyStartDate isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonStartDate;
    }
    else if ([SRGILMediaBlockingReasonKeyEndDate isEqualToString:[key uppercaseString]]) {
        return SRGILMediaBlockingReasonEndDate;
    }
    else {
        return SRGILMediaBlockingReasonNone;
    }
}

NSString *SRGILMediaBlockingReasonMessageForReason(SRGILMediaBlockingReason reason)
{
    switch (reason) {
        case SRGILMediaBlockingReasonGeoblock:
            return NSLocalizedString(@"BLOCKED_GEOBLOCK", nil);
        case SRGILMediaBlockingReasonLegal:
            return NSLocalizedString(@"BLOCKED_LEGAL", nil);
        case SRGILMediaBlockingReasonCommercial:
            return NSLocalizedString(@"BLOCKED_COMMERCIAL", nil);
        case SRGILMediaBlockingReasonAgeRating18:
            return NSLocalizedString(@"BLOCKED_AGERATING18", nil);
        case SRGILMediaBlockingReasonAgeRating12:
            return NSLocalizedString(@"BLOCKED_AGERATING12", nil);
                // FIXME warning check this is the correct message
        case SRGILMediaBlockingReasonStartDate:
            return NSLocalizedString(@"BLOCKED_STARTDATE", nil);
        case SRGILMediaBlockingReasonEndDate:
            return NSLocalizedString(@"BLOCKED_ENDDATE", nil);
        default:
            return @"";
    }
}

SRGILAssetSubSetType SRGILAssetSubSetTypeForString(NSString *subtypeString)
{
    SRGILAssetSubSetType result = SRGILAssetSubSetTypeUnknown;
    if (subtypeString) {
        if ([@"EPISODE" isEqualToString:subtypeString]) {
            return SRGILAssetSubSetTypeEpisode;
        }
        
        if ([@"TRAILER" isEqualToString:subtypeString]) {
            return SRGILAssetSubSetTypeTrailer;
        }
        
        if ([@"LIVESTREAM" isEqualToString:subtypeString]) {
            return SRGILAssetSubSetTypeLivestream;
        }
    }
    
    return result;
}

SRGILPlaylistProtocol SRGILPlayListProtocolForString(NSString *protocol)
{
    if (protocol) {
        if ([@"HTTP-HDS" isEqualToString:protocol]) {
            return SRGILPlaylistProtocolHDS;
        }
        if ([@"HTTP-HLS" isEqualToString:protocol]) {
            return SRGILPlaylistProtocolHLS;
        }
        if ([@"HTTP" isEqualToString:protocol]) {
            return SRGILPlaylistProtocolHTTP;
        }
        if ([@"RTMP" isEqualToString:protocol]) {
            return SRGILPlaylistProtocolRTMP;
        }
    }
    return SRGILPlaylistProtocolUnknown;
}

SRGILPlaylistURLQuality SRGILPlaylistURLQualityForString(NSString *quality)
{
    if (quality) {
        if ([@"SD" isEqualToString:quality]) {
            return SRGILPlaylistURLQualitySD;
        }
        if ([@"HD" isEqualToString:quality]) {
            return SRGILPlaylistURLQualityHD;
        }
        if ([@"SQ" isEqualToString:quality]) {
            return SRGILPlaylistURLQualitySQ;
        }
        if ([@"LQ" isEqualToString:quality]) {
            return SRGILPlaylistURLQualityLQ;
        }
        if ([@"MQ" isEqualToString:quality]) {
            return SRGILPlaylistURLQualityMQ;
        }
        if ([@"HQ" isEqualToString:quality]) {
            return SRGILPlaylistURLQualityHQ;
        }
    }
    return SRGILPlaylistURLQualityUnknown;
}

SRGILPlaylistSegmentation SRGILPlaylistSegmentationForString(NSString *segmentation)
{
    if (segmentation) {
        if ([@"PHYSICAL" isEqualToString:segmentation]) {
            return SRGILPlaylistSegmentationPhysical;
        }
        if ([@"LOGICAL" isEqualToString:segmentation]) {
            return SRGILPlaylistSegmentationLogical;
        }
    }
    return SRGILPlaylistSegmentationUnknown;
}
