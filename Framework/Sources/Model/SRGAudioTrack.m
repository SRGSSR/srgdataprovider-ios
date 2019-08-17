//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAudioTrack.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGAudioTrack ()

@property (nonatomic) SRGAudioTrackSource source;
@property (nonatomic) SRGAudioTrackType type;

@end

@implementation SRGAudioTrack

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mapping addEntriesFromDictionary:@{ @keypath(SRGAudioTrack.new, source) : @"source",
                                             @keypath(SRGAudioTrack.new, type) : @"type" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)sourceJSONTransformer
{
    return SRGAudioTrackSourceJSONTransformer();
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGAudioTrackTypeJSONTransformer();
}

@end
