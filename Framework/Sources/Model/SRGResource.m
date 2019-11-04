//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGResource ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) SRGQuality quality;
@property (nonatomic) SRGPresentation presentation;
@property (nonatomic, copy) NSString *MIMEType;
@property (nonatomic) SRGStreamingMethod streamingMethod;
@property (nonatomic, getter=isLive) BOOL live;
@property (nonatomic, getter=isDVR) BOOL DVR;
@property (nonatomic) SRGMediaContainer mediaContainer;
@property (nonatomic) SRGAudioCodec audioCodec;
@property (nonatomic) SRGVideoCodec videoCodec;
@property (nonatomic) SRGTokenType tokenType;
@property (nonatomic) NSArray<SRGDRM *> *DRMs;
@property (nonatomic) NSArray<SRGVariant *> *subtitleVariants;
@property (nonatomic) NSArray<SRGVariant *> *audioVariants;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;
@property (nonatomic) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;

@end

@implementation SRGResource

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGResource.new, URL) : @"url",
                       @keypath(SRGResource.new, quality) : @"quality",
                       @keypath(SRGResource.new, presentation) : @"presentation",
                       @keypath(SRGResource.new, MIMEType) : @"mimeType",
                       @keypath(SRGResource.new, streamingMethod) : @"streaming",
                       @keypath(SRGResource.new, live) : @"live",
                       @keypath(SRGResource.new, DVR) : @"dvr",
                       @keypath(SRGResource.new, mediaContainer) : @"mediaContainer",
                       @keypath(SRGResource.new, audioCodec) : @"audioCodec",
                       @keypath(SRGResource.new, videoCodec) : @"videoCodec",
                       @keypath(SRGResource.new, tokenType) : @"tokenType",
                       @keypath(SRGResource.new, DRMs) : @"drmList",
                       @keypath(SRGResource.new, subtitleVariants) : @"subtitleInformationList",
                       @keypath(SRGResource.new, audioVariants) : @"audioTrackList",
                       @keypath(SRGResource.new, analyticsLabels) : @"analyticsMetadata",
                       @keypath(SRGResource.new, comScoreAnalyticsLabels) : @"analyticsData" };
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (SRGStreamType)streamType
{
    if (self.DVR) {
        return SRGStreamTypeDVR;
    }
    else if (self.live) {
        return SRGStreamTypeLive;
    }
    else {
        return SRGStreamTypeOnDemand;
    }
}

#pragma mark Parsers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)qualityJSONTransformer
{
    return SRGQualityJSONTransformer();
}

+ (NSValueTransformer *)presentationJSONTransformer
{
    return SRGPresentationJSONTransformer();
}

+ (NSValueTransformer *)streamingMethodJSONTransformer
{
    return SRGStreamingMethodJSONTransformer();
}

+ (NSValueTransformer *)mediaContainerJSONTransformer
{
    return SRGMediaContainerJSONTransformer();
}

+ (NSValueTransformer *)audioCodecJSONTransformer
{
    return SRGAudioCodecJSONTransformer();
}

+ (NSValueTransformer *)videoCodecJSONTransformer
{
    return SRGVideoCodecJSONTransformer();
}

+ (NSValueTransformer *)tokenTypeJSONTransformer
{
    return SRGTokenTypeJSONTransformer();
}

+ (NSValueTransformer *)DRMsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGDRM.class];
}

+ (NSValueTransformer *)subtitleVariantsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGVariant.class];
}

+ (NSValueTransformer *)audioVariantsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGVariant.class];
}

#pragma mark Helpers

- (SRGDRM *)DRMWithType:(SRGDRMType)type
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGDRM.new, type), @(type)];
    return [self.DRMs filteredArrayUsingPredicate:predicate].firstObject;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGResource *otherResource = object;
    return [self.URL isEqual:otherResource.URL];
}

- (NSUInteger)hash
{
    return self.URL.hash;
}

@end

@implementation SRGResource (AudioVariants)

- (SRGVariantSource)recommendedAudioVariantSource
{
    SRGVariantSource source = SRGVariantSourceHLS;
    if ([self audioVariantsForSource:source].count != 0) {
        return source;
    }
    
    return SRGVariantSourceNone;
}

- (NSArray<SRGVariant *> *)audioVariantsForSource:(SRGVariantSource)source
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGVariant.new, source), @(source)];
    return [self.audioVariants filteredArrayUsingPredicate:predicate];
}

@end

@implementation SRGResource (SubtitleVariants)

- (SRGVariantSource)recommendedSubtitleVariantSource
{
    SRGVariantSource source = SRGVariantSourceHLS;
    if ([self subtitleVariantsForSource:source].count != 0) {
        return source;
    }
    
    return SRGVariantSourceNone;
}

- (NSArray<SRGVariant *> *)subtitleVariantsForSource:(SRGVariantSource)source
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGVariant.new, source), @(source)];
    return [self.subtitleVariants filteredArrayUsingPredicate:predicate];
}

@end
