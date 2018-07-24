//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDRM.h"

#import <libextobjc/libextobjc.h>

@interface SRGDRM ()

@property (nonatomic , copy) NSString *type;
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
                       @keypath(SRGDRM.new, licenseURL) : @"licenseUrl" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)licenseURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
