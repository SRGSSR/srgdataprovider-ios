//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentPage.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGContentPage ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, getter=isPublished) BOOL published;
@property (nonatomic, copy) NSString *topicURN;
@property (nonatomic) NSArray<SRGContentSection *> *sections;

@end

@implementation SRGContentPage

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGContentPage.new, uid) : @"id",
                       @keypath(SRGContentPage.new, vendor) : @"vendor",
                       @keypath(SRGContentPage.new, title) : @"title",
                       @keypath(SRGContentPage.new, published) : @"isPublished",
                       @keypath(SRGContentPage.new, topicURN) : @"topicUrn",
                       @keypath(SRGContentPage.new, sections) : @"sectionList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

+ (NSValueTransformer *)sectionsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGContentSection.class];
}

@end
