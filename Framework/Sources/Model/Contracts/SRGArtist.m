//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGArtist.h"

#import <libextobjc/libextobjc.h>

@interface SRGArtist ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, nullable) NSURL *URL;

@end

@implementation SRGArtist

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGArtist.new, name) : @"name",
                       @keypath(SRGArtist.new, URL) : @"url" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
