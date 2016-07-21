//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRelatedContent.h"

@interface SRGRelatedContent ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGRelatedContent

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"uid" : @"id",
                     @"title" : @"title",
                     @"lead" : @"lead",
                     @"summary" : @"description",
                     @"URL" : @"url" };
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
