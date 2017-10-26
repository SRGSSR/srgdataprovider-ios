//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"
#import "SRGMediaExtendedMetadata.h"

#import <libextobjc/libextobjc.h>

@interface SRGMedia () <SRGMediaExtendedMetadata>

@property (nonatomic) SRGChannel *channel;
@property (nonatomic) SRGEpisode *episode;
@property (nonatomic) SRGShow *show;

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
@property (nonatomic) SRGBlockingReason originalBlockingReason;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGMedia

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGMedia.new, channel) : @"channel",
                       @keypath(SRGMedia.new, episode) : @"episode",
                       @keypath(SRGMedia.new, show) : @"show",
                      
                       @keypath(SRGMedia.new, title) : @"title",
                       @keypath(SRGMedia.new, lead) : @"lead",
                       @keypath(SRGMedia.new, summary) : @"description",
                       
                       @keypath(SRGMedia.new, uid) : @"id",
                       @keypath(SRGMedia.new, URN) : @"urn",
                       @keypath(SRGMedia.new, mediaType) : @"mediaType",
                       @keypath(SRGMedia.new, vendor) : @"vendor",
                       
                       @keypath(SRGMedia.new, imageURL) : @"imageUrl",
                       @keypath(SRGMedia.new, imageTitle) : @"imageTitle",
                       @keypath(SRGMedia.new, imageCopyright) : @"imageCopyright",
                       
                       @keypath(SRGMedia.new, contentType) : @"type",
                       @keypath(SRGMedia.new, source) : @"assignedBy",
                       @keypath(SRGMedia.new, date) : @"date",
                       @keypath(SRGMedia.new, duration) : @"duration",
                       @keypath(SRGMedia.new, originalBlockingReason) : @"blockReason",
                       @keypath(SRGMedia.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGMedia.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGMedia.new, startDate) : @"validFrom",
                       @keypath(SRGMedia.new, endDate) : @"validTo",
                       @keypath(SRGMedia.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGMedia.new, socialCounts) : @"socialCountList" };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (SRGBlockingReason)blockingReasonAtDate:(NSDate *)date
{
    return SRGBlockingReasonForMediaMetadata(self, date);
}

#pragma mark Transformers

+ (NSValueTransformer *)channelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGChannel class]];
}

+ (NSValueTransformer *)episodeJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGEpisode class]];
}

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGShow class]];
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

+ (NSValueTransformer *)originalBlockingReasonJSONTransformer
{
    return SRGBlockingReasonJSONTransformer();
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
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSocialCount class]];
}

#pragma mark SRGImageMetadata protocol

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
    
    SRGMedia *otherMedia = object;
    return [self.URN isEqual:otherMedia.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
