//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAlbum.h"

@import libextobjc;

@interface SRGAlbum ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSURL *smallCoverImageURL;
@property (nonatomic) NSURL *largeCoverImageURL;

@end

@implementation SRGAlbum

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGAlbum.new, name) : @"name",
                       @keypath(SRGAlbum.new, smallCoverImageURL) : @"coverUrlSmall",
                       @keypath(SRGAlbum.new, largeCoverImageURL) : @"coverUrlLarge" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)smallCoverImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)largeCoverImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
