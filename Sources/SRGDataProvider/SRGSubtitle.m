//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubtitle.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

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
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{ @keypath(SRGSubtitle.new, format) : @"format",
                                             @keypath(SRGSubtitle.new, URL) : @"url" }];
        s_mapping = mapping.copy;
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
