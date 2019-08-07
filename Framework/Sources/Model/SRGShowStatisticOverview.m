//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShowStatisticOverview.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGShowStatisticOverview ()

@property (nonatomic) NSInteger searchResultClicked;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;

// To be conform to SRGShowIdentifierMetadata (nullable).
@property (nonatomic) SRGBroadcastInformation *broadcastInformation;

@end

@implementation SRGShowStatisticOverview

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGShowStatisticOverview.new, searchResultClicked) : @"searchResultClicked",
                        
                        @keypath(SRGShowStatisticOverview.new, uid) : @"id",
                        @keypath(SRGShowStatisticOverview.new, URN) : @"urn",
                        @keypath(SRGShowStatisticOverview.new, transmission) : @"transmission",
                        @keypath(SRGShowStatisticOverview.new, vendor) : @"vendor" };
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

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! object || ! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGShowStatisticOverview *otherOverview = object;
    return [self.URN isEqual:otherOverview.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
