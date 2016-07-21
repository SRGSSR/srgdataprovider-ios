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
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"format" : @"format",
                     @"URL" : @"url" };
    });
    return mapping;
}

+ (NSValueTransformer *)formatJSONTransformer
{
    return SRGSubtitleFormatJSONTransformer();
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
