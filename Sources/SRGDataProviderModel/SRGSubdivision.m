//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubdivision.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"
#import "SRGMediaExtendedMetadata.h"

@import libextobjc;

@interface SRGSubdivision () <SRGMediaExtendedMetadata>

@property (nonatomic, copy) NSString *fullLengthURN;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic, copy) NSString *event;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;
@property (nonatomic) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;
@property (nonatomic) NSArray<SRGSubtitle *> *subtitles;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@property (nonatomic) SRGContentType contentType;
@property (nonatomic) SRGSource source;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) SRGBlockingReason originalBlockingReason;
@property (nonatomic, getter=isPlayableAbroad) BOOL playableAbroad;
@property (nonatomic) SRGYouthProtectionColor youthProtectionColor;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic, copy) NSString *accessibilityTitle;
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
                       @keypath(SRGSubdivision.new, originalBlockingReason) : @"blockReason",
                       @keypath(SRGSubdivision.new, playableAbroad) : @"playableAbroad",
                       @keypath(SRGSubdivision.new, youthProtectionColor) : @"youthProtectionColor",
                       @keypath(SRGSubdivision.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGSubdivision.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGSubdivision.new, startDate) : @"validFrom",
                       @keypath(SRGSubdivision.new, endDate) : @"validTo",
                       @keypath(SRGSubdivision.new, accessibilityTitle) : @"mediaDescription",
                       @keypath(SRGSubdivision.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGSubdivision.new, socialCounts) : @"socialCountList" };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (SRGBlockingReason)blockingReasonAtDate:(NSDate *)date
{
    return SRGBlockingReasonForMediaMetadata(self, date);
}

- (SRGTimeAvailability)timeAvailabilityAtDate:(NSDate *)date
{
    return SRGTimeAvailabilityForMediaMetadata(self, date);
}

#pragma mark Transformers

+ (NSValueTransformer *)subtitlesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGSubtitle.class];
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

+ (NSValueTransformer *)originalBlockingReasonJSONTransformer
{
    return SRGBlockingReasonJSONTransformer();
}

+ (NSValueTransformer *)youthProtectionColorJSONTransformer
{
    return SRGYouthProtectionColorJSONTransformer();
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
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGRelatedContent.class];
}

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGSocialCount.class];
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGSubdivision *otherSubdivision = object;
    return [self.URN isEqual:otherSubdivision.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end

@implementation SRGSubdivision (Subtitles)

- (SRGSubtitleFormat)recommendedSubtitleFormat
{
    NSArray<NSNumber *> *subtitleFormats = @[ @(SRGSubtitleFormatVTT), @(SRGSubtitleFormatTTML) ];
    for (NSNumber *subtitleFormatNumber in subtitleFormats) {
        SRGSubtitleFormat subtitleFormat = subtitleFormatNumber.integerValue;
        if ([self subtitlesWithFormat:subtitleFormat].count != 0) {
            return subtitleFormat;
        }
    }
    
    return SRGSubtitleFormatNone;
}

- (NSArray<SRGSubtitle *> *)subtitlesWithFormat:(SRGSubtitleFormat)format
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGSubtitle.new, format), @(format)];
    return [self.subtitles filteredArrayUsingPredicate:predicate];
}

@end
