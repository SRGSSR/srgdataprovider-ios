//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"

#import "NSURL+SRGIntegrationLayerDataProvider.h"
#import "SRGJSONTransformers.h"

@interface SRGMedia ()

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *URN;
@property (nonatomic, copy) NSString *vendor;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;

@property (nonatomic) SRGContentType contentType;
@property (nonatomic) SRGSource source;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;

@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGMedia

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @"uid" : @"id",
                       @"URN" : @"urn",
                       @"vendor" : @"vendor",
                       @"mediaType" : @"mediaType",
                       @"title" : @"title",
                       @"lead" : @"lead",
                       @"summary" : @"description",
                       @"imageURL" : @"imageUrl",
                       @"imageTitle" : @"imageTitle",
                       @"contentType" : @"type",
                       @"source" : @"assignedBy",
                       @"date" : @"date",
                       @"duration" : @"duration",
                       @"podcastStandardDefinitionURL" : @"podcastSdUrl",
                       @"podcastHighDefinitionURL" : @"podcastHdUrl",
                       @"socialCounts" : @"socialCountList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)contentTypeJSONTransformer
{
    return SRGContentTypeJSONTransformer();
}

+ (NSValueTransformer *)sourceJSONTransformer
{
    return SRGSourceJSONTransformer();
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)podcastStandardDefinitionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastHighDefinitionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSocialCount class]];
}

@end
