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

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

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
 *  The unique identifier of the channel to which the show belongs.
 */
@property (nonatomic, readonly, copy, nullable) NSString *primaryChannelUid;

/**
 *  The number of episodes available for the show.
 */
@property (nonatomic, readonly) NSInteger numberOfEpisodes;

@end

NS_ASSUME_NONNULL_END
