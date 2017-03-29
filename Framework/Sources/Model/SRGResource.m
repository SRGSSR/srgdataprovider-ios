//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGResource ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGQuality quality;
@property (nonatomic) SRGProtocol protocol;
@property (nonatomic) SRGEncoding encoding;
@property (nonatomic, copy) NSString *MIMEType;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;

@end

@implementation SRGResource

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGResource.new, URL) : @"url",
                       @keypath(SRGResource.new, quality) : @"quality",
                       @keypath(SRGResource.new, protocol) : @"protocol",
                       @keypath(SRGResource.new, encoding) : @"encoding",
                       @keypath(SRGResource.new, presentation) : @"presentation",
                       @keypath(SRGResource.new, MIMEType) : @"mimeType",
                       @keypath(SRGResource.new, analyticsLabels) : @"analyticsData" };
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

+ (NSValueTransformer *)presentationJSONTransformer
{
    return SRGPresentationJSONTransformer();
}

@end
