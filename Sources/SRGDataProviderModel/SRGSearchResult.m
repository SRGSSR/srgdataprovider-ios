//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResult.h"

@import libextobjc;

@interface SRGSearchResult ()

@property (nonatomic, copy) NSString *URN;

@end

@implementation SRGSearchResult

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSearchResult.new, URN) : @"urn" };
    });
    return s_mapping;
}

@end
