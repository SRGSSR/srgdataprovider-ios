//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResultShow.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"
#import "SRGSearchResult+Private.h"

#import <libextobjc/libextobjc.h>

@interface SRGSearchResultShow ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;

@end

@implementation SRGSearchResultShow

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mapping addEntriesFromDictionary:@{ @keypath(SRGSearchResultShow.new, uid) : @"id",
                                             @keypath(SRGSearchResultShow.new, URN) : @"urn",
                                             @keypath(SRGSearchResultShow.new, transmission) : @"transmission",
                                             @keypath(SRGSearchResultShow.new, vendor) : @"vendor" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)transmissionJSONTransformer
{
    return SRGTransmissionJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

#pragma mark Overrides

// TODO: This override is only required because of uid-based image URL overriding. Drop when image overriding is not
//       required anymore.
- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:self.uid type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGSearchResultShow *otherSearchResultShow = object;
    return [self.URN isEqual:otherSearchResultShow.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
