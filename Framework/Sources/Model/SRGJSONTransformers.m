//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGJSONTransformers.h"

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NSValueTransformer *SRGContentTypeJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EPISODE": @(SRGContentTypeEpisode) }];
    });
    return transformer;
}

NSValueTransformer *SRGEncodingJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"MPEG4": @(SRGEncodingMPEG4),
                                                                                       @"H264" : @(SRGEncodingH264) }];
    });
    return transformer;
}

NSValueTransformer *SRGMediaTypeJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"VIDEO": @(SRGMediaTypeVideo),
                                                                                       @"AUDIO": @(SRGMediaTypeAudio) }];
    });
    return transformer;
}

NSValueTransformer *SRGProtocolJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"HLS": @(SRGProtocolHLS),
                                                                                       @"HDS": @(SRGProtocolHDS),
                                                                                       @"HTTP": @(SRGProtocolHTTP) }];
        
    });
    return transformer;
}

NSValueTransformer *SRGQualityJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"SD": @(SRGQualityStandard),
                                                                                       @"HD": @(SRGQualityHigh) }];
    });
    return transformer;
}

NSValueTransformer *SRGSourceJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EDITOR": @(SRGSourceEditor),
                                                                                       @"TRENDING" : @(SRGSourceTrending) }];
    });
    return transformer;
}

NSValueTransformer *SRGSubtitleFormatJSONTransformer(void)
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"TTML": @(SRGSubtitleFormatTTML) }];
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
