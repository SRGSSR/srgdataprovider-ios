//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"

@interface SRGResource ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGQuality quality;
@property (nonatomic) SRGProtocol protocol;
@property (nonatomic) SRGEncoding encoding;

@end

@implementation SRGResource

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"URL" : @"url",
              @"quality" : @"quality",
              @"protocol" : @"protocol",
              @"encoding" : @"encoding" };
}

#pragma mark Parsers

+ (NSValueTransformer *)qualityJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"SD": @(SRGQualityStandard),
                                                                            @"HD": @(SRGQualityHigh) }];
}

+ (NSValueTransformer *)protocolJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"HLS": @(SRGProtocolHLS),
                                                                            @"HDS": @(SRGProtocolHDS),
                                                                            @"HTTP": @(SRGProtocolHTTP) }];
}

+ (NSValueTransformer *)encodingJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"MPEG4": @(SRGEncodingMPEG4) }];
}

@end
