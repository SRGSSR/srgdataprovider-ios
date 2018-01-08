//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBaseTopic.h"

#import <libextobjc/libextobjc.h>

@interface SRGBaseTopic ()

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@end

@implementation SRGBaseTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGBaseTopic.new, uid) : @"id",
                       
                       @keypath(SRGBaseTopic.new, title) : @"title",
                       @keypath(SRGBaseTopic.new, lead) : @"lead",
                       @keypath(SRGBaseTopic.new, summary) : @"description" };
    });
    return s_mapping;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGBaseTopic *otherBaseTopic = object;
    return [self.uid isEqualToString:otherBaseTopic.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
