//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDRM.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGDRM ()

@property (nonatomic) SRGDRMType type;
@property (nonatomic) NSURL *certificateURL;
@property (nonatomic) NSURL *licenseURL;

@end

@implementation SRGDRM

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGDRM.new, type) : @"type",
                       @keypath(SRGDRM.new, certificateURL) : @"certificateUrl",
                       @keypath(SRGDRM.new, licenseURL) : @"licenseUrl" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGDRMTypeJSONTransformer();
}

+ (NSValueTransformer *)certificateURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)licenseURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
