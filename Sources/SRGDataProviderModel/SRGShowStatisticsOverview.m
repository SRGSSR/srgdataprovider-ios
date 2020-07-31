//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShowStatisticsOverview.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGShowStatisticsOverview ()

@property (nonatomic) NSInteger searchResultsViewCount;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;

// To be conform to SRGShowIdentifierMetadata (nullable).
@property (nonatomic) SRGBroadcastInformation *broadcastInformation;

@end

@implementation SRGShowStatisticsOverview

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGShowStatisticsOverview.new, searchResultsViewCount) : @"searchResultClicked",
                       
                       @keypath(SRGShowStatisticsOverview.new, uid) : @"id",
                       @keypath(SRGShowStatisticsOverview.new, URN) : @"urn",
                       @keypath(SRGShowStatisticsOverview.new, transmission) : @"transmission",
                       @keypath(SRGShowStatisticsOverview.new, vendor) : @"vendor" };
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
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGShowStatisticsOverview *otherOverview = object;
    return [self.URN isEqual:otherOverview.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
