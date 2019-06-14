//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubtitle.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGSubtitle ()

@property (nonatomic) SRGSubtitleFormat format;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic) SRGQualifier qualifier;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGSubtitle

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSubtitle.new, format) : @"format",
                       @keypath(SRGSubtitle.new, language) : @"language",
                       @keypath(SRGSubtitle.new, locale) : @"locale",
                       @keypath(SRGSubtitle.new, qualifier) : @"qualifier",
                       @keypath(SRGSubtitle.new, URL) : @"url" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)formatJSONTransformer
{
    return SRGSubtitleFormatJSONTransformer();
}

+ (NSValueTransformer *)qualifierJSONTransformer
{
    return SRGQualifierJSONTransformer();
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
