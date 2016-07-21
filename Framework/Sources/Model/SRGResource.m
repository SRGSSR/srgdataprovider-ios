//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"

#import "SRGJSONTransformers.h"

@interface SRGResource ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGQuality quality;
@property (nonatomic) SRGProtocol protocol;
@property (nonatomic) SRGEncoding encoding;
@property (nonatomic, copy) NSString *MIMEType;

@end

@implementation SRGResource

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @"URL" : @"url",
                       @"quality" : @"quality",
                       @"protocol" : @"protocol",
                       @"encoding" : @"encoding",
                       @"MIMEType" : @"mimeType" };
    });
    return s_mapping;
}

#pragma mark Parsers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)qualityJSONTransformer
{
    return SRGQualityJSONTransformer();
}

+ (NSValueTransformer *)protocolJSONTransformer
{
    return SRGProtocolJSONTransformer();
}

+ (NSValueTransformer *)encodingJSONTransformer
{
    return SRGEncodingJSONTransformer();
}

@end
