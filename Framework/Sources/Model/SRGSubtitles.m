//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubtitles.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGSubtitles ()

@property (nonatomic) NSArray<SRGLanguage *> *externalLanguages;
@property (nonatomic) NSArray<SRGLanguage *> *HLSLanguages;
@property (nonatomic) NSArray<SRGLanguage *> *HDSLanguages;
@property (nonatomic) NSArray<SRGLanguage *> *DASHLanguages;

@end

@implementation SRGSubtitles

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSubtitles.new, externalLanguages) : @"EXTERNAL",
                       @keypath(SRGSubtitles.new, HLSLanguages) : @"HLS",
                       @keypath(SRGSubtitles.new, HDSLanguages) : @"HDS",
                       @keypath(SRGSubtitles.new, DASHLanguages) : @"DASH" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)externalLanguagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGLanguage.class];
}

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
