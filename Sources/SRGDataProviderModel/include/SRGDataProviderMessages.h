//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Return a suggested error message for a chapter or a media blocking reason (a full episode is blocked, or we just
 *  have a media object), `nil` if none.
 */
OBJC_EXPORT NSString * _Nullable SRGMessageForBlockedMediaWithBlockingReason(SRGBlockingReason blockingReason);

/**
 *  Return a suggested error message for a segment blocking reason (just a segment of an episode is blocked, and
 *  skipped during the playback), `nil` if none.
 */
OBJC_EXPORT NSString * _Nullable SRGMessageForSkippedSegmentWithBlockingReason(SRGBlockingReason blockingReason);

/**
 *  Return a suggested information message for a given youth protection color, `nil` if none.
 */
OBJC_EXPORT NSString * _Nullable SRGMessageForYouthProtectionColor(SRGYouthProtectionColor youthProtectionColor);

/**
 *  Return a suggested accessibility label for a given youth protection color, `nil` if none.
 */
OBJC_EXPORT NSString * _Nullable SRGAccessibilityLabelForYouthProtectionColor(SRGYouthProtectionColor youthProtectionColor);


NS_ASSUME_NONNULL_END
