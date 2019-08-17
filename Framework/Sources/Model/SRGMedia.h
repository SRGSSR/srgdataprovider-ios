//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAudioTrack.h"
#import "SRGMediaMetadata.h"
#import "SRGMediaParentMetadata.h"
#import "SRGModel.h"
#import "SRGSubtitleInformation.h"

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
 *  Audio tracks informations.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGAudioTrack *> *audioTracks;

/**
 *  Subtitles informations.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSubtitleInformation *> *subtitleInformations;

@end

@interface SRGMedia (AudioTracks)

/**
 *  The recommended audio track source that can be used. Might return `SRGAudioTrackSourceNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGAudioTrackSource recommendedAudioTrackSource;

/**
 *  Return audio tracks matching the specified source.
 */
- (nullable NSArray<SRGAudioTrack *> *)audioTracksForSource:(SRGAudioTrackSource)audioTrackSource;

@end

@interface SRGMedia (SubtitleInformations)

/**
 *  The recommended subtitles information source that can be used. Might return `SRGSubtitleInformationSourceNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGSubtitleInformationSource recommendedSubtitleInformationSource;

/**
 *  Return subtitles informations matching the specified source.
 */
- (nullable NSArray<SRGSubtitleInformation *> *)subtitleInformationsForSource:(SRGSubtitleInformationSource)subtitleInformationSource;

@end

NS_ASSUME_NONNULL_END
