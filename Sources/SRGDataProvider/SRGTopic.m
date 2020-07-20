//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopic.h"

@import libextobjc;

@interface SRGTopic ()

@property (nonatomic) NSArray<SRGSubtopic *> *subtopics;

@end

@implementation SRGTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{ @keypath(SRGTopic.new, subtopics) : @"subTopicList" }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)subtopicsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGSubtopic.class];
}

@end
