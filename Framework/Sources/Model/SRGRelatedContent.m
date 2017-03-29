//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRelatedContent.h"

#import <libextobjc/libextobjc.h>

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
        s_mapping = @{ @keypath(SRGRelatedContent.new, uid) : @"id",
                       @keypath(SRGRelatedContent.new, URL) : @"url",
                       
                       @keypath(SRGRelatedContent.new, title) : @"title",
                       @keypath(SRGRelatedContent.new, lead) : @"lead",
                       @keypath(SRGRelatedContent.new, summary) : @"description" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGRelatedContent *otherRelatedContent = object;
    return [self.uid isEqualToString:otherRelatedContent.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
