//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGJSONTransformers.h"

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NSValueTransformer *SRGBlockingReasonJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"GEOBLOCK" : @(SRGBlockingReasonGeoblocking),
                                                                                       @"LEGAL" : @(SRGBlockingReasonLegal),
                                                                                       @"COMMERCIAL" : @(SRGBlockingReasonCommercial),
                                                                                       @"AGERATING18" : @(SRGBlockingReasonAgeRating18),
                                                                                       @"AGERATING12" : @(SRGBlockingReasonAgeRating12),
                                                                                       @"STARTDATE" : @(SRGBlockingReasonStartDate),
                                                                                       @"ENDDATE" : @(SRGBlockingReasonEndDate),
                                                                                       @"UNKNOWN" : @(SRGBlockingReasonUnknown) }];
    });
    return transformer;
}

NSValueTransformer *SRGContentTypeJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EPISODE" : @(SRGContentTypeEpisode),
                                                                                       @"TRAILER" : @(SRGContentTypeTrailer),
                                                                                       @"CLIP" : @(SRGContentTypeClip),
                                                                                       @"LIVESTREAM" : @(SRGContentTypeLivestream),
                                                                                       @"SCHEDULED_LIVESTREAM" : @(SRGContentTypeScheduledLivestream) }];
    });
    return transformer;
}

NSValueTransformer *SRGEncodingJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"H264" : @(SRGEncodingH264),
                                                                                       @"VP6F" : @(SRGEncodingVP6F),
                                                                                       @"MPEG2" : @(SRGEncodingMPEG2),
                                                                                       @"WMV3" : @(SRGEncodingWMV3),
                                                                                       @"MPEG4" : @(SRGEncodingMPEG4),
                                                                                       @"AAC" : @(SRGEncodingAAC),
                                                                                       @"AAC-HE" : @(SRGEncodingAAC_HE),
                                                                                       @"MP3" : @(SRGEncodingMP3),
                                                                                       @"MP2" : @(SRGEncodingMP2),
                                                                                       @"WMAV2" : @(SRGEncodingWMAV2) }];
    });
    return transformer;
}

NSValueTransformer *SRGMediaTypeJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"VIDEO" : @(SRGMediaTypeVideo),
                                                                                       @"AUDIO" : @(SRGMediaTypeAudio) }];
    });
    return transformer;
}

NSValueTransformer *SRGProtocolJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"HLS" : @(SRGProtocolHLS),
                                                                                       @"HDS" : @(SRGProtocolHDS),
                                                                                       @"RTMP" : @(SRGProtocolRTMP),
                                                                                       @"HTTP" : @(SRGProtocolHTTP) }];
        
    });
    return transformer;
}

NSValueTransformer *SRGQualityJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"SD" : @(SRGQualitySD),
                                                                                       @"HD" : @(SRGQualityHD),
                                                                                       @"HQ" : @(SRGQualityHQ) }];
    });
    return transformer;
}

NSValueTransformer *SRGSourceJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EDITOR" : @(SRGSourceEditor),
                                                                                       @"TRENDING" : @(SRGSourceTrending),
                                                                                       @"RECOMMENDATION" : @(SRGSourceRecommendation) }];
    });
    return transformer;
}

NSValueTransformer *SRGSubtitleFormatJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"TTML" : @(SRGSubtitleFormatTTML),
                                                                                       @"VTT" : @(SRGSubtitleFormatVTT) }];
    });
    return transformer;
}

NSValueTransformer *SRGISO8601DateJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        
        transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
            return [dateFormatter dateFromString:dateString];
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [dateFormatter stringFromDate:date];
        }];
    });
    return transformer;
}
