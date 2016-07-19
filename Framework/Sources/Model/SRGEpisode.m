//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEpisode.h"

@interface SRGEpisode ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSURL *imageURL;

@end

@implementation SRGEpisode

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"uid" : @"id",
              @"title" : @"title",
              @"imageURL" : @"imageUrl" };
}

#pragma mark Transformers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
