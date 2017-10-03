//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGMetadata.h"
#import "SRGRelatedContent.h"
#import "SRGSocialCount.h"
#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Media availability. Only contents which are available should be playable client-side.
 */
typedef NS_ENUM(NSInteger, SRGMediaAvailability) {
    /**
     *  Not specified.
     */
    SRGMediaAvailabilityNone = 0,
    /**
     *  The media is not yet available.
     */
    SRGMediaAvailabilityNotYetAvailable,
    /**
     *  The media is available.
     */
    SRGMediaAvailabilityAvailable,
    /**
     *  The media has expired and is not available anymore.
     */
    SRGMediaAvailabilityNotAvailableAnymore,
    /**
     *  The media is blocked (for a reason other than its availability period).
     */
    SRGMediaAvailabilityBlocked
};

/**
 *  Common protocol for medias.
 */
@protocol SRGMediaMetadata <SRGMetadata, SRGMediaIdentifierMetadata, SRGImageMetadata>

/**
 *  The type of the content (episode, trailer, etc.).
 */
@property (nonatomic, readonly) SRGContentType contentType;

/**
 *  The source which provided the media.
 */
@property (nonatomic, readonly) SRGSource source;

/**
 *  The media date.
 */
@property (nonatomic, readonly) NSDate *date;

/**
 *  The media duration in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 *  Return whether media playback should be blocked client-side. If `SRGBlockingReasonNone`, the media can be
 *  freely played.
 *
 *  @discussion To check for media availability, use `SRGDataProviderAvailabilityForMediaMetadata`.
 */
@property (nonatomic, readonly) SRGBlockingReason blockingReason;

/**
 *  The standard definition podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastStandardDefinitionURL;

/**
 *  The high-definition podcast URL.
 */
@property (nonatomic, readonly, nullable) NSURL *podcastHighDefinitionURL;

/**
 *  The start date at which the content should be made available, if such restrictions exist.
 *
 *  @discussion To check for media availability, use `SRGDataProviderAvailabilityForMediaMetadata`.
 */
@property (nonatomic, readonly, nullable) NSDate *startDate;

/**
 *  The end date at which the content should not be made available anymore, if such restrictions exist.
 *
 *  @discussion To check for media availability, use `SRGDataProviderAvailabilityForMediaMetadata`.
 */
@property (nonatomic, readonly, nullable) NSDate *endDate;

/**
 *  The list of contents related to the media.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGRelatedContent *> *relatedContents;

/**
 *  Social network and popularity information.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSocialCount *> *socialCounts;

@end

/**
 *  Return the availability of the given media metadata.
 *
 *  @discussion This function combines several information from `SRGMediaMetadata` to determine media availability in
 *              a consistent and reliable way.
 */
OBJC_EXTERN SRGMediaAvailability SRGDataProviderAvailabilityForMediaMetadata(_Nullable id<SRGMediaMetadata> mediaMetadata);

NS_ASSUME_NONNULL_END
