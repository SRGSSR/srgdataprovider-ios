//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEpisode.h"

@implementation SRGEpisode

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"uid" : @"id",
              @"title" : @"title",
              @"imageURL" : @"imageUrl" };
}

#pragma mark Parsers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
