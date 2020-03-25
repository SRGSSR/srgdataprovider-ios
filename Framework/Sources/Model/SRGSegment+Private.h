//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSegment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This function takes a list of segments as input, and sanitizes it so that:
 *    - Invalid segments are removed (zero duration or mark-in larger than mark-out).
 *    - Segments are guaranteed to be disjoint.
 *    - Blocked content can never be played.
 *    - Segments might be repeated several times when cut by another segment.
 *    - Positions are fixed to match the cleaned up list.
 */
OBJC_EXTERN NSArray<__kindof SRGSegment *> *SRGSanitizedSegments(NSArray<SRGSegment *> * _Nullable segments);

@interface SRGSegment (Private)

/**
 *  Internally used to associate with a parent chapter date, if any.
 */
@property (nonatomic, nullable) NSDate *referenceDate;

@end

NS_ASSUME_NONNULL_END
