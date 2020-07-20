//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGServiceMessage.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGServiceMessage ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGServiceMessage

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGServiceMessage.new, uid) : @"id",
                       @keypath(SRGServiceMessage.new, text) : @"text",
                       @keypath(SRGServiceMessage.new, date) : @"modifyDate",
                       @keypath(SRGServiceMessage.new, URL) : @"url" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)dateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGServiceMessage *otherServiceMessage = object;
    return [self.uid isEqualToString:otherServiceMessage.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
