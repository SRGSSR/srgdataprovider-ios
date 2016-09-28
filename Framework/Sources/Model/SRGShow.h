//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show
 */
@interface SRGShow : MTLModel <SRGImageMetadata, SRGMetadata, MTLJSONSerializing>

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

@end

NS_ASSUME_NONNULL_END
