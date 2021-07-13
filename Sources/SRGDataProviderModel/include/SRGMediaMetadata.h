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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

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
 *  Return the blocking reason associated with the media (if any), calculated at the specified date. The media
 *  should be playable client-side iff the reason is `SRGBlockingReasonNone`.
 */
- (SRGBlockingReason)blockingReasonAtDate:(NSDate *)date;

/**
 *  Return the time availability associated with the media at the specified date.
 *
 *  @discussion Time availability is only intended for informative purposes. To decide whether a media should be playable
 *              client-side, use `-blockingReasonAtDate:`.
 */
- (SRGTimeAvailability)timeAvailabilityAtDate:(NSDate *)date;

/**
 *  Return `YES` if the content is playable outside Switzerland.
 */
@property (nonatomic, readonly, getter=isPlayableAbroad) BOOL playableAbroad;

/**
 *  The youth protection color.
 */
@property (nonatomic, readonly) SRGYouthProtectionColor youthProtectionColor;

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
 */
@property (nonatomic, readonly, nullable) NSDate *startDate;

/**
 *  The end date at which the content should not be made available anymore, if such restrictions exist.
 */
@property (nonatomic, readonly, nullable) NSDate *endDate;

/**
 *  Title suited for accessibility purposes (e.g. VoiceOver).
 */
@property (nonatomic, readonly, copy, nullable) NSString *accessibilityTitle;

/**
 *  The list of contents related to the media.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGRelatedContent *> *relatedContents;

/**
 *  Social network and popularity information.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
