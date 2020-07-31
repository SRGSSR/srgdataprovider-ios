//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGVariant.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGVariant ()

@property (nonatomic) NSLocale *locale;
@property (nonatomic, copy) NSString *language;
@property (nonatomic) SRGVariantSource source;
@property (nonatomic) SRGVariantType type;

@end

@implementation SRGVariant

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGVariant.new, locale) : @"locale",
                       @keypath(SRGVariant.new, language) : @"language",
                       @keypath(SRGVariant.new, source) : @"source",
                       @keypath(SRGVariant.new, type) : @"type" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)localeJSONTransformer
{
    return SRGLocaleJSONTransformer();
}

+ (NSValueTransformer *)sourceJSONTransformer
{
    return SRGVariantSourceJSONTransformer();
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGVariantTypeJSONTransformer();
}

@end
