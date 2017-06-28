//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaRepresentation.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGMediaRepresentation ()

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

@implementation SRGMediaRepresentation

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGMediaRepresentation.new, fullLengthURN) : @"fullLengthUrn",
                       @keypath(SRGMediaRepresentation.new, position) : @"position",
                       @keypath(SRGMediaRepresentation.new, markIn) : @"markIn",
                       @keypath(SRGMediaRepresentation.new, markOut) : @"markOut",
                       @keypath(SRGMediaRepresentation.new, event) : @"eventData",
                       @keypath(SRGMediaRepresentation.new, analyticsLabels) : @"analyticsData",
                       @keypath(SRGMediaRepresentation.new, subtitles) : @"subtitleList",
                       
                       @keypath(SRGMediaRepresentation.new, title) : @"title",
                       @keypath(SRGMediaRepresentation.new, lead) : @"lead",
                       @keypath(SRGMediaRepresentation.new, summary) : @"description",
                       
                       @keypath(SRGMediaRepresentation.new, uid) : @"id",
                       @keypath(SRGMediaRepresentation.new, URN) : @"urn",
                       @keypath(SRGMediaRepresentation.new, mediaType) : @"mediaType",
                       @keypath(SRGMediaRepresentation.new, vendor) : @"vendor",
                       
                       @keypath(SRGMediaRepresentation.new, imageURL) : @"imageUrl",
                       @keypath(SRGMediaRepresentation.new, imageTitle) : @"imageTitle",
                       @keypath(SRGMediaRepresentation.new, imageCopyright) : @"imageCopyright",
                       
                       @keypath(SRGMediaRepresentation.new, contentType) : @"type",
                       @keypath(SRGMediaRepresentation.new, source) : @"assignedBy",
                       @keypath(SRGMediaRepresentation.new, date) : @"date",
                       @keypath(SRGMediaRepresentation.new, duration) : @"duration",
                       @keypath(SRGMediaRepresentation.new, blockingReason) : @"blockReason",
                       @keypath(SRGMediaRepresentation.new, hidden) : @"displayable",
                       @keypath(SRGMediaRepresentation.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGMediaRepresentation.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGMediaRepresentation.new, startDate) : @"validFrom",
                       @keypath(SRGMediaRepresentation.new, endDate) : @"validTo",
                       @keypath(SRGMediaRepresentation.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGMediaRepresentation.new, socialCounts) : @"socialCountList" };
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
    
    SRGMediaRepresentation *otherMediaRepresentation = object;
    return [self.uid isEqualToString:otherMediaRepresentation.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end
