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
                                                                                         @"UNKNOWN" : @(SRGBlockingReasonUnknown) }
                                                                         defaultValue:@(SRGBlockingReasonNone)
                                                                  reverseDefaultValue:nil];
    });
    return s_transformer;
}

NSValueTransformer *SRGBooleanInversionJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @(YES) : @(NO),
                                                                                         @(NO) : @(YES) }
                                                                         defaultValue:@(YES)
                                                                  reverseDefaultValue:nil];
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
                                                                                         @"SCHEDULED_LIVESTREAM" : @(SRGContentTypeScheduledLivestream) }
                                                                         defaultValue:@(SRGContentTypeNone)
                                                                  reverseDefaultValue:nil];
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
                                                                                         @"AAC" : @(SRGEncodingAAC),
                                                                                         @"AAC-HE" : @(SRGEncodingAAC_HE),
                                                                                         @"MP3" : @(SRGEncodingMP3),
                                                                                         @"MP2" : @(SRGEncodingMP2),
                                                                                         @"WMAV2" : @(SRGEncodingWMAV2) }
                                                                         defaultValue:@(SRGEncodingNone)
                                                                  reverseDefaultValue:nil];
    });
    return s_transformer;
}

NSValueTransformer *SRGMediaTypeJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"VIDEO" : @(SRGMediaTypeVideo),
                                                                                         @"AUDIO" : @(SRGMediaTypeAudio) }
                                                                         defaultValue:@(SRGMediaTypeNone)
                                                                  reverseDefaultValue:nil];
    });
    return s_transformer;
}

NSValueTransformer *SRGMediaURNJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URNString, BOOL *success, NSError *__autoreleasing *error) {
            return [SRGMediaURN mediaURNWithString:URNString];
        } reverseBlock:^id(SRGMediaURN *mediaURN, BOOL *success, NSError *__autoreleasing *error) {
            return mediaURN.URNString;
        }];
    });
    return s_transformer;
}

NSValueTransformer *SRGModuleTypeJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EVENT" : @(SRGModuleTypeEvent) }
                                                                         defaultValue:@(SRGModuleTypeNone)
                                                                  reverseDefaultValue:nil];
    });
    return s_transformer;
}

NSValueTransformer *SRGProtocolJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"HLS" : @(SRGProtocolHLS),
                                                                                         @"HLS-DVR" : @(SRGProtocolHLS_DVR),
                                                                                         @"HDS" : @(SRGProtocolHDS),
                                                                                         @"HDS-DVR" : @(SRGProtocolHDS_DVR),
                                                                                         @"RTMP" : @(SRGProtocolRTMP),
                                                                                         @"HTTP" : @(SRGProtocolHTTP),
                                                                                         @"HTTPS" : @(SRGProtocolHTTPS),
                                                                                         @"HTTP-M3U" : @(SRGProtocolHTTP_M3U),
                                                                                         @"HTTP-MP3-STREAM" : @(SRGProtocolHTTP_MP3Stream) }
                                                                         defaultValue:@(SRGProtocolNone)
                                                                  reverseDefaultValue:nil];
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
                                                                                         @"HQ" : @(SRGQualityHQ) }
                                                                         defaultValue:@(SRGQualityNone)
                                                                  reverseDefaultValue:nil];
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
                                                                                        @"whatsAppShare": @(SRGSocialCountTypeWhatsAppShare) }
                                                                        defaultValue:@(SRGSocialCountTypeNone)
                                                                 reverseDefaultValue:nil];
    });
    return transformer;
}

NSValueTransformer *SRGSourceJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EDITOR" : @(SRGSourceEditor),
                                                                                         @"TRENDING" : @(SRGSourceTrending),
                                                                                         @"RECOMMENDATION" : @(SRGSourceRecommendation) }
                                                                         defaultValue:@(SRGSourceNone)
                                                                  reverseDefaultValue:nil];
    });
    return s_transformer;
}

NSValueTransformer *SRGSubtitleFormatJSONTransformer(void)
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"TTML" : @(SRGSubtitleFormatTTML),
                                                                                         @"VTT" : @(SRGSubtitleFormatVTT) }
                                                                         defaultValue:@(SRGSubtitleFormatNone)
                                                                  reverseDefaultValue:nil];
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
                                                                                         @"UNKNOWN" : @(SRGTransmissionUnknown) }
                                                                         defaultValue:@(SRGTransmissionNone)
                                                                  reverseDefaultValue:nil];
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
                                                                                         @"SWI" : @(SRGVendorSWI) }
                                                                         defaultValue:@(SRGVendorNone)
                                                                  reverseDefaultValue:nil];
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
        } reverseBlock:^id(UIColor *color, BOOL *success, NSError *__autoreleasing *error) {
            const CGFloat *components = CGColorGetComponents(color.CGColor);
            
            CGFloat r = components[0];
            CGFloat g = components[1];
            CGFloat b = components[2];
            
            return [NSString stringWithFormat:@"%02lX%02lX%02lX",
                    lroundf(r * 255),
                    lroundf(g * 255),
                    lroundf(b * 255)];
        }];
    });
    return s_transformer;
}
