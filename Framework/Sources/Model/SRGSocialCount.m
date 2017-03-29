//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSocialCount.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGSocialCount ()

@property (nonatomic) SRGSocialCountType type;
@property (nonatomic) NSInteger value;

@end

@implementation SRGSocialCount

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSocialCount.new, type) : @"key",
                       @keypath(SRGSocialCount.new, value) : @"value" };
    });
    return s_mapping;
}

#pragma mark Parsers

+ (NSValueTransformer *)typeJSONTransformer
{
    return SRGSocialCountTypeJSONTransformer();
}

@end
