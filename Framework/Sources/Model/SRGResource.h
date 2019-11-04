//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDRM.h"
#import "SRGModel.h"
#import "SRGVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A resource provides a media URL and its description (quality, encoding, etc.).
 */
@interface SRGResource : SRGModel

/**
 *  The media URL.
 */
@property (nonatomic, readonly) NSURL *URL;

/**
 *  The media quality (standard, high definition, ...).
 */
@property (nonatomic, readonly) SRGQuality quality;

/**
 *  The recommended way to present the resource.
 */
@property (nonatomic, readonly) SRGPresentation presentation;

/**
 *  The media MIME type.
 */
@property (nonatomic, readonly, copy, nullable) NSString *MIMEType;

/**
 *  The streaming method.
 */
@property (nonatomic, readonly) SRGStreamingMethod streamingMethod;

/**
 *  The stream type.
 */
@property (nonatomic, readonly) SRGStreamType streamType;

/**
 *  The media container.
 */
@property (nonatomic, readonly) SRGMediaContainer mediaContainer;

/**
 *  The audio codec.
 */
@property (nonatomic, readonly) SRGAudioCodec audioCodec;

/**
 *  The video codec.
 */
@property (nonatomic, readonly) SRGVideoCodec videoCodec;

/**
 *  The type of token to use for playback.
 */
@property (nonatomic, readonly) SRGTokenType tokenType;

/**
 *  The list of DRMs providers supported by the stream.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGDRM *> *DRMs;

/**
 *  The subtitle variants available from the stream.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGVariant *> *subtitleVariants;

/**
 *  The audio variants available from the stream.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGVariant *> *audioVariants;

/**
 *  The list of labels which should be supplied in SRG Analytics player events.
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *analyticsLabels;

/**
 *  The list of comScore labels which should be supplied in SRG Analytics player events.
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;

@end

@interface SRGResource (DRMs)

/**
 *  Return information for a DRM of the specified type, if available for the receiver.
 */
- (nullable SRGDRM *)DRMWithType:(SRGDRMType)type;

@end

@interface SRGResource (AudioVariants)

/**
 *  The recommended audio variant source to use. Might return `SRGVariantSourceNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGVariantSource recommendedAudioVariantSource;

/**
 *  Return audio variants matching the specified source.
 */
- (nullable NSArray<SRGVariant *> *)audioVariantsForSource:(SRGVariantSource)source;

@end

@interface SRGResource (SubtitleVariants)

/**
 *  The recommended subtitle variant source to use. Might return `SRGVariantSourceNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGVariantSource recommendedSubtitleVariantSource;

/**
 *  Return subtitle variants matching the specified source.
 */
- (nullable NSArray<SRGVariant *> *)subtitleVariantsForSource:(SRGVariantSource)source;

@end


NS_ASSUME_NONNULL_END
