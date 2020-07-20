//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"
#import "SRGMediaParentMetadata.h"
#import "SRGModel.h"
#import "SRGVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A media (audio or video). This is a lightweight representation (which does not contain the URLs to be played,
 *  most notably). For complete playack context information, an `SRGMediaComposition` must be requested.
 */
@interface SRGMedia : SRGModel <SRGMediaMetadata, SRGMediaParentMetadata>

/**
 *  The recommended way to present the media.
 */
@property (nonatomic, readonly) SRGPresentation presentation;

/**
 *  Available audio variants.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGVariant *> *audioVariants;

/**
 *  Available subtitle variants.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGVariant *> *subtitleVariants;

@end

@interface SRGMedia (AudioVariants)

/**
 *  The recommended audio variant source to use. Might return `SRGVariantSourceNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGVariantSource recommendedAudioVariantSource;

/**
 *  Return audio variants matching the specified source.
 */
- (nullable NSArray<SRGVariant *> *)audioVariantsForSource:(SRGVariantSource)source;

@end

@interface SRGMedia (SubtitleVariants)

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
