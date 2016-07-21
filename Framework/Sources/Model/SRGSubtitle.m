//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubtitle.h"

#import "SRGJSONTransformers.h"

@interface SRGSubtitle ()

@property (nonatomic) SRGSubtitleFormat format;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGSubtitle

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @"format" : @"format",
                       @"URL" : @"url" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)formatJSONTransformer
{
    return SRGSubtitleFormatJSONTransformer();
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
