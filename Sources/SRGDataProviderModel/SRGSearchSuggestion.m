//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchSuggestion.h"

@import libextobjc;

@interface SRGSearchSuggestion ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSInteger numberOfExactMatches;

@end

@implementation SRGSearchSuggestion

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSearchSuggestion.new, text) : @"text",
                       @keypath(SRGSearchSuggestion.new, numberOfExactMatches) : @"exactMatchTotal" };
    });
    return s_mapping;
}

@end
