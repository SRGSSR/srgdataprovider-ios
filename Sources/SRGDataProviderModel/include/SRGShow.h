//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGShowIdentifierMetadata.h"
#import "SRGTypes.h"

@import CoreGraphics;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

// Supported alternative image types
OBJC_EXPORT SRGImageType const SRGImageTypeShowBanner;          // Show banner image.

/**
 *  Show information.
 */
@interface SRGShow : SRGModel <SRGImageMetadata, SRGMetadata, SRGShowIdentifierMetadata>

/**
 *  The URL of the show homepage.
 */
@property (nonatomic, readonly, nullable) NSURL *homepageURL;

/**
 *  The URL for podcast subscriptions.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastSubscriptionURL;

/**
 *  The high-definition podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastStandardDefinitionURL;

/**
 *  The standard definition podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastHighDefinitionURL;

/**
 *  The Deezer podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastDeezerURL;

/**
 *  The Spotify podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastSpotifyURL;

/**
 *  The unique identifier of the channel to which the show belongs.
 */
@property (nonatomic, readonly, copy, nullable) NSString *primaryChannelUid;

/**
 *  The number of episodes available for the show.
 */
@property (nonatomic, readonly, nullable) NSNumber *numberOfEpisodes;

@end

NS_ASSUME_NONNULL_END
