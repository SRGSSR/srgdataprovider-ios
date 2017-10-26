//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Extended media metadata protocol. For internal use only.
 */
@protocol SRGMediaExtendedMetadata <SRGMediaMetadata>

/**
 *  The original blocking reason received in metadata.
 */
@property (nonatomic, readonly) SRGBlockingReason originalBlockingReason;

@end

/**
 *  Return the effective blocking reason for a given media metadata, at the specified date.
 *
 *  @discussion This function combines several information from `SRGMediaMetadata` to determine whether a media is effectively
 *              blocked or not at the given date.
 */
OBJC_EXTERN SRGBlockingReason SRGBlockingReasonForMediaMetadata(_Nullable id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date);

/**
 *  Return the time availability associated with the media, calculated at the specified date.
 *
 *  @discussion Used only for UI. `SRGBlockingReasonForMediaMetadata()` fonction is the real reason if a media cannot be played.
 */
OBJC_EXTERN SRGMediaTimeAvailability SRGTimeAvailabilityForMediaMetadata(_Nullable id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date);

NS_ASSUME_NONNULL_END
