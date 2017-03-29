//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopic.h"

#import <libextobjc/libextobjc.h>

@interface SRGTopic ()

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@end

@implementation SRGTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGTopic.new, uid) : @"id",
                       
                       @keypath(SRGTopic.new, title) : @"title",
                       @keypath(SRGTopic.new, lead) : @"lead",
                       @keypath(SRGTopic.new, summary) : @"description" };
    });
    return s_mapping;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGTopic *otherTopic = object;
    return [self.uid isEqualToString:otherTopic.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
