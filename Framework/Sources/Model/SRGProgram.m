//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGProgram.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGProgram ()

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGShow *show;
@property (nonatomic) SRGPresenter *presenter;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGProgram

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGProgram.new, startDate) : @"startTime",
                       @keypath(SRGProgram.new, endDate) : @"endTime",
                       @keypath(SRGProgram.new, URL) : @"url",
                       @keypath(SRGProgram.new, show) : @"show",
                       @keypath(SRGProgram.new, presenter) : @"presenter",
                       
                       @keypath(SRGProgram.new, title) : @"title",
                       @keypath(SRGProgram.new, lead) : @"lead",
                       @keypath(SRGProgram.new, summary) : @"description",
                       
                       @keypath(SRGProgram.new, imageURL) : @"imageUrl",
                       @keypath(SRGProgram.new, imageTitle) : @"imageTitle",
                       @keypath(SRGProgram.new, imageCopyright) : @"imageCopyright" };
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

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGShow class]];
}

+ (NSValueTransformer *)presenterJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGPresenter class]];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark SRGImageMetadata protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(NSString *)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:nil type:type];
}

@end
