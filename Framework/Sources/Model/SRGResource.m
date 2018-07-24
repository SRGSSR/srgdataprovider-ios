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
@property (nonatomic) NSArray<SRGDRM *> *DRMs;
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
                       @keypath(SRGResource.new, DRMs) : @"drmList",
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

+ (NSValueTransformer *)DRMsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGDRM class]];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! object || ! [object isKindOfClass:[self class]]) {
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
