//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBroadcastInformation.h"

#import "SRGJSONTransformers.h"

@import libextobjc;

@interface SRGBroadcastInformation ()

@property (nonatomic, copy) NSString *message;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic, nullable) NSURL *URL;

@end

@implementation SRGBroadcastInformation

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGBroadcastInformation.new, message) : @"hintText",
                       @keypath(SRGBroadcastInformation.new, startDate) : @"startDate",
                       @keypath(SRGBroadcastInformation.new, endDate) : @"endDate",
                       @keypath(SRGBroadcastInformation.new, URL) : @"url" };
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

@end
