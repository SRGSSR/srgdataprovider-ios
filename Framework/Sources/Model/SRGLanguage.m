//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLanguage.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGLanguage ()

@property (nonatomic, copy) NSLocale *locale;
@property (nonatomic) SRGQualifier qualifier;
@property (nonatomic, copy) NSString *language;

@end

@implementation SRGLanguage

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGLanguage.new, locale) : @"locale",
                       @keypath(SRGLanguage.new, qualifier) : @"qualifier",
                       @keypath(SRGLanguage.new, language) : @"language" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)localeJSONTransformer
{
    return SRGLocaleJSONTransformer();
}

+ (NSValueTransformer *)qualifierJSONTransformer
{
    return SRGQualifierJSONTransformer();
}

@end
