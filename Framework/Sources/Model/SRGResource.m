//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"

@interface SRGResource ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGResourceQuality quality;
@property (nonatomic) SRGResourceProtocol protocol;
@property (nonatomic) SRGResourceEncoding encoding;

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
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"SD": @(SRGResourceQualityStandard),
                                                                            @"HD": @(SRGResourceQualityHigh) }];
}

+ (NSValueTransformer *)protocolJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"HLS": @(SRGResourceProtocolHLS),
                                                                            @"HDS": @(SRGResourceProtocolHDS),
                                                                            @"HTTP": @(SRGResourceProtocolHTTP) }];
}

+ (NSValueTransformer *)encodingJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"MPEG4": @(SRGResourceEncodingMPEG4) }];
}

@end
