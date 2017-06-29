//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSubdivision.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGMediaSubdivision ()

@property (nonatomic) SRGMediaURN *fullLengthURN;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;
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
@property (nonatomic) SRGBlockingReason blockingReason;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGMediaSubdivision

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGMediaSubdivision.new, fullLengthURN) : @"fullLengthUrn",
                       @keypath(SRGMediaSubdivision.new, position) : @"position",
                       @keypath(SRGMediaSubdivision.new, markIn) : @"markIn",
                       @keypath(SRGMediaSubdivision.new, markOut) : @"markOut",
                       @keypath(SRGMediaSubdivision.new, event) : @"eventData",
                       @keypath(SRGMediaSubdivision.new, analyticsLabels) : @"analyticsData",
                       @keypath(SRGMediaSubdivision.new, subtitles) : @"subtitleList",
                       
                       @keypath(SRGMediaSubdivision.new, title) : @"title",
                       @keypath(SRGMediaSubdivision.new, lead) : @"lead",
                       @keypath(SRGMediaSubdivision.new, summary) : @"description",
                       
                       @keypath(SRGMediaSubdivision.new, uid) : @"id",
                       @keypath(SRGMediaSubdivision.new, URN) : @"urn",
                       @keypath(SRGMediaSubdivision.new, mediaType) : @"mediaType",
                       @keypath(SRGMediaSubdivision.new, vendor) : @"vendor",
                       
                       @keypath(SRGMediaSubdivision.new, imageURL) : @"imageUrl",
                       @keypath(SRGMediaSubdivision.new, imageTitle) : @"imageTitle",
                       @keypath(SRGMediaSubdivision.new, imageCopyright) : @"imageCopyright",
                       
                       @keypath(SRGMediaSubdivision.new, contentType) : @"type",
                       @keypath(SRGMediaSubdivision.new, source) : @"assignedBy",
                       @keypath(SRGMediaSubdivision.new, date) : @"date",
                       @keypath(SRGMediaSubdivision.new, duration) : @"duration",
                       @keypath(SRGMediaSubdivision.new, blockingReason) : @"blockReason",
                       @keypath(SRGMediaSubdivision.new, hidden) : @"displayable",
                       @keypath(SRGMediaSubdivision.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGMediaSubdivision.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGMediaSubdivision.new, startDate) : @"validFrom",
                       @keypath(SRGMediaSubdivision.new, endDate) : @"validTo",
                       @keypath(SRGMediaSubdivision.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGMediaSubdivision.new, socialCounts) : @"socialCountList" };
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

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(NSString *)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:self.uid type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGMediaSubdivision *otherMediaSubdivision = object;
    return [self.uid isEqualToString:otherMediaSubdivision.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
