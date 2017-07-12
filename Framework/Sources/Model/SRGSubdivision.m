//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubdivision.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGSubdivision ()

@property (nonatomic) SRGMediaURN *fullLengthURN;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic, copy) NSString *event;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;
@property (nonatomic) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;
@property (nonatomic) NSArray<SRGSubtitle *> *subtitles;

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
@property (nonatomic) SRGBlockingReason blockingReason;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGSubdivision

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSubdivision.new, fullLengthURN) : @"fullLengthUrn",
                       @keypath(SRGSubdivision.new, position) : @"position",
                       @keypath(SRGSubdivision.new, markIn) : @"markIn",
                       @keypath(SRGSubdivision.new, markOut) : @"markOut",
                       @keypath(SRGSubdivision.new, hidden) : @"displayable",
                       @keypath(SRGSubdivision.new, event) : @"eventData",
                       @keypath(SRGSubdivision.new, analyticsLabels) : @"analyticsMetadata",
                       @keypath(SRGSubdivision.new, comScoreAnalyticsLabels) : @"analyticsData",
                       @keypath(SRGSubdivision.new, subtitles) : @"subtitleList",
                       
                       @keypath(SRGSubdivision.new, title) : @"title",
                       @keypath(SRGSubdivision.new, lead) : @"lead",
                       @keypath(SRGSubdivision.new, summary) : @"description",
                       
                       @keypath(SRGSubdivision.new, uid) : @"id",
                       @keypath(SRGSubdivision.new, URN) : @"urn",
                       @keypath(SRGSubdivision.new, mediaType) : @"mediaType",
                       @keypath(SRGSubdivision.new, vendor) : @"vendor",
                       
                       @keypath(SRGSubdivision.new, imageURL) : @"imageUrl",
                       @keypath(SRGSubdivision.new, imageTitle) : @"imageTitle",
                       @keypath(SRGSubdivision.new, imageCopyright) : @"imageCopyright",
                       
                       @keypath(SRGSubdivision.new, contentType) : @"type",
                       @keypath(SRGSubdivision.new, source) : @"assignedBy",
                       @keypath(SRGSubdivision.new, date) : @"date",
                       @keypath(SRGSubdivision.new, duration) : @"duration",
                       @keypath(SRGSubdivision.new, blockingReason) : @"blockReason",
                       @keypath(SRGSubdivision.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGSubdivision.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGSubdivision.new, startDate) : @"validFrom",
                       @keypath(SRGSubdivision.new, endDate) : @"validTo",
                       @keypath(SRGSubdivision.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGSubdivision.new, socialCounts) : @"socialCountList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)fullLengthURNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
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

+ (NSValueTransformer *)blockingReasonJSONTransformer
{
    return SRGBlockingReasonJSONTransformer();
}

+ (NSValueTransformer *)hiddenJSONTransformer
{
    return SRGBooleanInversionJSONTransformer();
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

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:self.uid type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGSubdivision *otherSubdivision = object;
    return [self.uid isEqualToString:otherSubdivision.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
