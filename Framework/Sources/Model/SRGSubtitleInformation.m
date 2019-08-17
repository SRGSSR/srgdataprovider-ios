//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubtitleInformation.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGSubtitleInformation ()

@property (nonatomic) SRGSubtitleInformationSource source;
@property (nonatomic) SRGSubtitleInformationType type;

@end

@implementation SRGSubtitleInformation

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mapping addEntriesFromDictionary:@{ @keypath(SRGSubtitleInformation.new, source) : @"source",
                                             @keypath(SRGSubtitleInformation.new, type) : @"type" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)sourceJSONTransformer
{
    return SRGSubtitleInformationSourceJSONTransformer();
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGSubtitleInformationTypeJSONTransformer();
}

@end
