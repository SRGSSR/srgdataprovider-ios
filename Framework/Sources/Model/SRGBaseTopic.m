//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBaseTopic.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGBaseTopic ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGTopicURN *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;

@end

@implementation SRGBaseTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGBaseTopic.new, title) : @"title",
                       @keypath(SRGBaseTopic.new, lead) : @"lead",
                       @keypath(SRGBaseTopic.new, summary) : @"description",
                        
                       @keypath(SRGBaseTopic.new, uid) : @"id",
                       @keypath(SRGBaseTopic.new, URN) : @"urn",
                       @keypath(SRGBaseTopic.new, transmission) : @"transmission",
                       @keypath(SRGBaseTopic.new, vendor) : @"vendor" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URNJSONTransformer
{
    return SRGTopicURNJSONTransformer();
}

+ (NSValueTransformer *)transmissionJSONTransformer
{
    return SRGTransmissionJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
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
