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
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"URL" : @"url",
                     @"quality" : @"quality",
                     @"protocol" : @"protocol",
                     @"encoding" : @"encoding",
                     @"MIMEType" : @"mimeType" };
    });
    return mapping;
}

#pragma mark Parsers

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
