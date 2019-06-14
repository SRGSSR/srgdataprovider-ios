//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAudios.h"
#import "SRGMediaMetadata.h"
#import "SRGMediaParentMetadata.h"
#import "SRGModel.h"
#import "SRGSubtitles.h"

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
 *  Audio tracks information.
 */
@property (nonatomic, readonly, nullable) SRGAudios *audios;

/**
 *  Subtitles information.
 */
@property (nonatomic, readonly, nullable) SRGSubtitles *subtitles;

@end

NS_ASSUME_NONNULL_END
