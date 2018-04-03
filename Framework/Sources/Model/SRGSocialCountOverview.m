//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSocialCountOverview.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGSocialCountOverview ()

@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;

@end

@implementation SRGSocialCountOverview

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSocialCountOverview.new, socialCounts) : @"socialCountList",
                        
                        @keypath(SRGSocialCountOverview.new, uid) : @"id",
                        @keypath(SRGSocialCountOverview.new, URN) : @"urn",
                        @keypath(SRGSocialCountOverview.new, mediaType) : @"mediaType",
                        @keypath(SRGSocialCountOverview.new, vendor) : @"vendor" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSocialCount class]];
}

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
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
    
    SRGSocialCountOverview *otherLike = object;
    return [self.URN isEqual:otherLike.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
