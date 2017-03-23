//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show
 */
@interface SRGShow : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  The unique identifier of the show
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The URL of the show homepage
 */
@property (nonatomic, readonly, nullable) NSURL *homepageURL;

/**
 *  The URL for podcast subscriptions
 */
@property (nonatomic, readonly, nullable) NSURL *podcastSubscriptionURL;

/**
 *  The unique identifier of the channel to which the show belongs
 */
@property (nonatomic, readonly, copy, nullable) NSString *primaryChannelUid;

/**
 *  The number of episodes available for the show
 */
@property (nonatomic, readonly) NSInteger numberOfEpisodes;

@end

@interface SRGShow (Images)

/**
 *  Return the URL for a banner image with the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered
 *
 *  @param dimension The dimension (horizontal or vertical)
 *  @param value     The value along the specified dimensions, in points (independent of the device scale)
 */
- (nullable NSURL *)bannerImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
