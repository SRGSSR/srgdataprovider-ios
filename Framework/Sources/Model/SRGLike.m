//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLike.h"

#import "SRGJSONTransformers.h"

@interface SRGLike ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic, copy) NSString *vendor;
@property (nonatomic, copy) NSString *URN;

@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGLike

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"uid" : @"id",
                     @"mediaType" : @"mediaType",
                     @"vendor" : @"vendor",
                     @"URN" : @"urn",
                     @"socialCounts" : @"socialCountList" };
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSocialCount class]];
}

@end
