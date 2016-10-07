//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEvent.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGEvent ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
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

@end

@implementation SRGEvent

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGEvent.new, uid) : @"id",
                       @keypath(SRGEvent.new, startDate) : @"publishStartTimestamp",
                       @keypath(SRGEvent.new, endDate) : @"publishEndTimestamp",
                       @keypath(SRGEvent.new, backgroundImageURL) : @"bgImageUrl",
                       @keypath(SRGEvent.new, headerBackgroundColor) : @"headerBackgroundColor",
                       @keypath(SRGEvent.new, headerTextColor) : @"headerTitleColor",
                       @keypath(SRGEvent.new, backgroundColor) : @"bgColor",
                       @keypath(SRGEvent.new, textColor) : @"textColor",
                       @keypath(SRGEvent.new, linkColor) : @"linkColor",
                       @keypath(SRGEvent.new, logoImageURL) : @"logoImageUrl",
                       @keypath(SRGEvent.new, keyVisualImageURL) : @"keyVisualImageUrl",
                       @keypath(SRGEvent.new, websiteTitle) : @"microSiteTitle",
                       @keypath(SRGEvent.new, websiteURL) : @"microSiteUrl",
                       @keypath(SRGEvent.new, sections) : @"sectionList",
                       
                       @keypath(SRGEvent.new, title) : @"title",
                       @keypath(SRGEvent.new, lead) : @"lead",
                       @keypath(SRGEvent.new, summary) : @"description" };
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
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSection class]];
}

@end
