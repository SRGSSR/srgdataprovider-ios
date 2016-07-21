//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGIntegrationLayerDataProvider.h"

@interface SRGChapter ()

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

@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;

@property (nonatomic) NSArray<SRGResource *> *resources;
@property (nonatomic) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic) NSArray<SRGSubtitle *> *subtitles;

@end

@implementation SRGChapter

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"uid" : @"id",
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
                     @"position" : @"position",
                     @"markIn" : @"markIn",
                     @"markOut" : @"markOut",
                     @"resources" : @"resourceList",
                     @"relatedContents" : @"relatedContentList",
                     @"subtitles" : @"subtitleList" };
    });
    return mapping;
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

+ (NSValueTransformer *)resourcesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGResource class]];
}

+ (NSValueTransformer *)relatedContentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGRelatedContent class]];
}

+ (NSValueTransformer *)subtitlesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSubtitle class]];
}

@end
