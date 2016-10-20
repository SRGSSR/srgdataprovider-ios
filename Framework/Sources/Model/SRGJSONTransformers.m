//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGJSONTransformers.h"

#import "SRGTypes.h"

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

NSValueTransformer *SRGBlockingReasonJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"GEOBLOCK" : @(SRGBlockingReasonGeoblocking),
                                                                                         @"LEGAL" : @(SRGBlockingReasonLegal),
                                                                                         @"COMMERCIAL" : @(SRGBlockingReasonCommercial),
                                                                                         @"AGERATING18" : @(SRGBlockingReasonAgeRating18),
                                                                                         @"AGERATING12" : @(SRGBlockingReasonAgeRating12),
                                                                                         @"STARTDATE" : @(SRGBlockingReasonStartDate),
                                                                                         @"ENDDATE" : @(SRGBlockingReasonEndDate),
                                                                                         @"UNKNOWN" : @(SRGBlockingReasonUnknown) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGContentTypeJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EPISODE" : @(SRGContentTypeEpisode),
                                                                                         @"TRAILER" : @(SRGContentTypeTrailer),
                                                                                         @"CLIP" : @(SRGContentTypeClip),
                                                                                         @"LIVESTREAM" : @(SRGContentTypeLivestream),
                                                                                         @"SCHEDULED_LIVESTREAM" : @(SRGContentTypeScheduledLivestream) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGEncodingJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"H264" : @(SRGEncodingH264),
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
    return s_transformer;
}

NSValueTransformer *SRGHiddenJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @(YES) : @(NO),
                                                                                         @(NO) : @(YES) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGMediaTypeJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"VIDEO" : @(SRGMediaTypeVideo),
                                                                                         @"AUDIO" : @(SRGMediaTypeAudio) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGProtocolJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"HLS" : @(SRGProtocolHLS),
                                                                                         @"HDS" : @(SRGProtocolHDS),
                                                                                         @"RTMP" : @(SRGProtocolRTMP),
                                                                                         @"HTTP" : @(SRGProtocolHTTP) }];
        
    });
    return s_transformer;
}

NSValueTransformer *SRGQualityJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"SD" : @(SRGQualitySD),
                                                                                         @"HD" : @(SRGQualityHD),
                                                                                         @"HQ" : @(SRGQualityHQ) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGSocialCountTypeJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer =  [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"srgView": @(SRGSocialCountTypeSRGView),
                                                                                        @"srgLike": @(SRGSocialCountTypeSRGLike),
                                                                                        @"fbShare": @(SRGSocialCountTypeFacebookShare),
                                                                                        @"twitterShare": @(SRGSocialCountTypeTwitterShare),
                                                                                        @"googleShare": @(SRGSocialCountTypeGooglePlusShare),
                                                                                        @"whatsAppShare": @(SRGSocialCountTypeWhatsAppShare) }];    });
    return transformer;
}

NSValueTransformer *SRGSourceJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EDITOR" : @(SRGSourceEditor),
                                                                                         @"TRENDING" : @(SRGSourceTrending),
                                                                                         @"RECOMMENDATION" : @(SRGSourceRecommendation) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGSubtitleFormatJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"TTML" : @(SRGSubtitleFormatTTML),
                                                                                         @"VTT" : @(SRGSubtitleFormatVTT) }];
    });
    return s_transformer;
}

OBJC_EXPORT NSValueTransformer *SRGTransmissionJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"TV" : @(SRGTransmissionTV),
                                                                                         @"RADIO" : @(SRGTransmissionRadio),
                                                                                         @"ONLINE" : @(SRGTransmissionOnline),
                                                                                         @"UNKNOWN" : @(SRGTransmissionUnknown) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGVendorJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"RSI" : @(SRGVendorRSI),
                                                                                         @"RTR" : @(SRGVendorRTR),
                                                                                         @"RTS" : @(SRGVendorRTS),
                                                                                         @"SRF" : @(SRGVendorSRF),
                                                                                         @"SWI" : @(SRGVendorSWI) }];
    });
    return s_transformer;
}

NSValueTransformer *SRGISO8601DateJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
            return [dateFormatter dateFromString:dateString];
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [dateFormatter stringFromDate:date];
        }];
    });
    return s_transformer;
}

NSValueTransformer *SRGHexColorJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *hexColorString, BOOL *success, NSError *__autoreleasing *error) {
            NSScanner *scanner = [NSScanner scannerWithString:hexColorString];
            if ([hexColorString hasPrefix:@"#"]) {
                [scanner setScanLocation:1];
            }
            
            unsigned rgbValue = 0;
            [scanner scanHexInt:&rgbValue];
            
            CGFloat red = ((rgbValue & 0xFF0000) >> 16) / 255.f;
            CGFloat green = ((rgbValue & 0x00FF00) >> 8) / 255.f;
            CGFloat blue = (rgbValue & 0x0000FF) / 255.f;
            return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
        } reverseBlock:nil];
    });
    return s_transformer;
}
