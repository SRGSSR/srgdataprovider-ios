//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopic.h"

@implementation SRGTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mappings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Start with all properties and deal only with exceptions
        NSMutableDictionary *mutableMappings = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
        mutableMappings[@"uid"] = @"id";
        mappings = [mutableMappings copy];
    });
    return mappings;
}

@end
