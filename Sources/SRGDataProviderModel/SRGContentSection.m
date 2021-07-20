//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentSection.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGContentSection ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic) SRGContentSectionType type;
@property (nonatomic, getter=isPublished) BOOL published;
@property (nonatomic, getter=isPersonalized) BOOL personalized;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) SRGContentPresentation *presentation;

@end

@implementation SRGContentSection

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGContentSection.new, uid) : @"id",
                       @keypath(SRGContentSection.new, vendor) : @"vendor",
                       @keypath(SRGContentSection.new, type) : @"sectionType",
                       @keypath(SRGContentSection.new, published) : @"isPublished",
                       @keypath(SRGContentSection.new, personalized) : @"hasPersonalizedContent",
                       @keypath(SRGContentSection.new, startDate) : @"start",
                       @keypath(SRGContentSection.new, endDate) : @"end",
                       @keypath(SRGContentSection.new, presentation) : @"representation" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGContentSectionTypeJSONTransformer();
}

+ (NSValueTransformer *)startDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)endDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)presentationJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGContentPresentation.class];
}

@end
