//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSection.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGSection ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@end

@implementation SRGSection

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSection.new, uid) : @"id",
                       @keypath(SRGSection.new, startDate) : @"publishStartTimestamp",
                       @keypath(SRGSection.new, endDate) : @"publishEndTimestamp",
                       
                       @keypath(SRGSection.new, title) : @"title",
                       @keypath(SRGSection.new, lead) : @"lead",
                       @keypath(SRGSection.new, summary) : @"description" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)startDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)endDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGSection *otherSection = object;
    return [self.uid isEqualToString:otherSection.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
