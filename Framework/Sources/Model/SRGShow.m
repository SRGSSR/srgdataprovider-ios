//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShow.h"

@implementation SRGShow

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"uid" : @"id",
              @"title" : @"title",
              @"imageURL" : @"imageUrl",
              @"homepageURL" : @"homepageUrl" };
}

#pragma mark Parsers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)homepageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
