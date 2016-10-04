//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRelatedContent.h"

@interface SRGRelatedContent ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) NSURL *URL;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@end

@implementation SRGRelatedContent

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @"uid" : @"id",
                       @"URL" : @"url",
                       
                       @"title" : @"title",
                       @"lead" : @"lead",
                       @"summary" : @"description" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
