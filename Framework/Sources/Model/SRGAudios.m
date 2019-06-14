//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAudios.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGAudios ()

@property (nonatomic) NSArray<SRGLanguage *> *HLSLanguages;
@property (nonatomic) NSArray<SRGLanguage *> *HDSLanguages;
@property (nonatomic) NSArray<SRGLanguage *> *DASHLanguages;

@end

@implementation SRGAudios

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGAudios.new, HLSLanguages) : @"HLS",
                       @keypath(SRGAudios.new, HDSLanguages) : @"HDS",
                       @keypath(SRGAudios.new, DASHLanguages) : @"DASH" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)HLSLanguagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGLanguage.class];
}

+ (NSValueTransformer *)HDSLanguagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGLanguage.class];
}

+ (NSValueTransformer *)DASHLanguagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGLanguage.class];
}

@end
