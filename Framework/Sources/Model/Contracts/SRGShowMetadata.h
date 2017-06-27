//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGShowIdentifierMetadata.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for shows.
 */
@protocol SRGShowMetadata <SRGMetadata, SRGImageMetadata, SRGShowIdentifierMetadata>

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

/**
 *  Return the URL for a banner image with the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered.
 *
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in pixels.
 *
 *  @discussion The device scale is NOT automatically taken into account. Be sure that the required size in pixels
 *              matches the scale of your device.
 */
- (nullable NSURL *)bannerImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
