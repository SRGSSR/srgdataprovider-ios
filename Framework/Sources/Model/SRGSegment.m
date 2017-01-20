//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSegment.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGSegment ()

@property (nonatomic, copy) NSString *fullLengthURN;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;
@property (nonatomic) SRGBlockingReason blockingReason;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic, copy) NSString *event;
@property (nonatomic) NSArray<SRGSubtitle *> *subtitles;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGMediaURN *URN;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@property (nonatomic) SRGContentType contentType;
@property (nonatomic) SRGSource source;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGSegment

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSegment.new, fullLengthURN) : @"fullLengthUrn",
                       @keypath(SRGSegment.new, position) : @"position",
                       @keypath(SRGSegment.new, markIn) : @"markIn",
                       @keypath(SRGSegment.new, markOut) : @"markOut",
                       @keypath(SRGSegment.new, blockingReason) : @"blockReason",
                       @keypath(SRGSegment.new, hidden) : @"displayable",
                       @keypath(SRGSegment.new, event) : @"eventData",
                       @keypath(SRGSegment.new, analyticsLabels) : @"analyticsData",
                       @keypath(SRGSegment.new, subtitles) : @"subtitleList",
                       
                       @keypath(SRGSegment.new, title) : @"title",
                       @keypath(SRGSegment.new, lead) : @"lead",
                       @keypath(SRGSegment.new, summary) : @"description",
                       
                       @keypath(SRGSegment.new, uid) : @"id",
                       @keypath(SRGSegment.new, URN) : @"urn",
                       @keypath(SRGSegment.new, mediaType) : @"mediaType",
                       @keypath(SRGSegment.new, vendor) : @"vendor",
                       
                       @keypath(SRGSegment.new, imageURL) : @"imageUrl",
                       @keypath(SRGSegment.new, imageTitle) : @"imageTitle",
                       @keypath(SRGSegment.new, imageCopyright) : @"imageCopyright",
                       
                       @keypath(SRGSegment.new, contentType) : @"type",
                       @keypath(SRGSegment.new, source) : @"assignedBy",
                       @keypath(SRGSegment.new, date) : @"date",
                       @keypath(SRGSegment.new, duration) : @"duration",
                       @keypath(SRGSegment.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGSegment.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGSegment.new, startDate) : @"validFrom",
                       @keypath(SRGSegment.new, endDate) : @"validTo",
                       @keypath(SRGSegment.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGSegment.new, socialCounts) : @"socialCountList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)blockingReasonJSONTransformer
{
    return SRGBlockingReasonJSONTransformer();
}

+ (NSValueTransformer *)hiddenJSONTransformer
{
    return SRGBooleanInversionJSONTransformer();
}

+ (NSValueTransformer *)subtitlesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSubtitle class]];
}

+ (NSValueTransformer *)URNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
}

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
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

+ (NSValueTransformer *)startDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)endDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)relatedContentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGRelatedContent class]];
}

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGRelatedContent class]];
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value];
}

@end
