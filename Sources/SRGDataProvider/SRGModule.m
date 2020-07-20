//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModule.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

@import libextobjc;

SRGImageType const SRGImageTypeModuleBackground = @"background";
SRGImageType const SRGImageTypeModuleKeyVisual = @"key_visual";
SRGImageType const SRGImageTypeModuleLogo = @"logo";

@interface SRGModule ()

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic, copy) NSString *seoName;
@property (nonatomic) NSURL *backgroundImageURL;
@property (nonatomic) UIColor *headerBackgroundColor;
@property (nonatomic) UIColor *headerTextColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *linkColor;
@property (nonatomic) NSURL *logoImageURL;
@property (nonatomic) NSURL *keyVisualImageURL;
@property (nonatomic, copy) NSString *websiteTitle;
@property (nonatomic) NSURL *websiteURL;
@property (nonatomic) NSArray<SRGSection *> *sections;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGModuleType moduleType;
@property (nonatomic) SRGVendor vendor;

@end

@implementation SRGModule

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGModule.new, startDate) : @"publishStartTimestamp",
                       @keypath(SRGModule.new, endDate) : @"publishEndTimestamp",
                       @keypath(SRGModule.new, seoName) : @"seoName",
                       @keypath(SRGModule.new, backgroundImageURL) : @"bgImageUrl",
                       @keypath(SRGModule.new, headerBackgroundColor) : @"headerBackgroundColor",
                       @keypath(SRGModule.new, headerTextColor) : @"headerTitleColor",
                       @keypath(SRGModule.new, backgroundColor) : @"bgColor",
                       @keypath(SRGModule.new, textColor) : @"textColor",
                       @keypath(SRGModule.new, linkColor) : @"linkColor",
                       @keypath(SRGModule.new, logoImageURL) : @"logoImageUrl",
                       @keypath(SRGModule.new, keyVisualImageURL) : @"keyVisualImageUrl",
                       @keypath(SRGModule.new, websiteTitle) : @"microSiteTitle",
                       @keypath(SRGModule.new, websiteURL) : @"microSiteUrl",
                       @keypath(SRGModule.new, sections) : @"sectionList",
                       
                       @keypath(SRGModule.new, title) : @"title",
                       @keypath(SRGModule.new, lead) : @"lead",
                       @keypath(SRGModule.new, summary) : @"description",
                       
                       @keypath(SRGModule.new, uid) : @"id",
                       @keypath(SRGModule.new, URN) : @"urn",
                       @keypath(SRGModule.new, moduleType) : @"moduleConfigType",
                       @keypath(SRGModule.new, vendor) : @"vendor" };
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

+ (NSValueTransformer *)backgroundImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)headerBackgroundColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)headerTextColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)backgroundColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)textColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)linkColorJSONTransformer
{
    return SRGHexColorJSONTransformer();
}

+ (NSValueTransformer *)logoImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)keyVisualImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)sectionsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGSection.class];
}

+ (NSValueTransformer *)moduleTypeJSONTransformer
{
    return SRGModuleTypeJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    if ([type isEqualToString:SRGImageTypeModuleBackground]) {
        return [self.backgroundImageURL srg_URLForDimension:dimension withValue:value type:type];
    }
    else if ([type isEqualToString:SRGImageTypeModuleLogo]) {
        return [self.logoImageURL srg_URLForDimension:dimension withValue:value type:type];
    }
    else {
        return [self.keyVisualImageURL srg_URLForDimension:dimension withValue:value type:type];
    }
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGModule *otherModule = object;
    return [self.uid isEqualToString:otherModule.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
