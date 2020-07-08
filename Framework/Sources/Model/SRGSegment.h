//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubdivision.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A segment is piece of a physical media.
 */
@interface SRGSegment : SRGSubdivision

/**
 *  The time at which the segment starts, in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval markIn;

/**
 *  The time at which the segment ends, in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval markOut;

@end

@interface SRGSegment (Dates)

/**
 *  The date corresponding to the mark in time, `nil` if no such relationship exists.
 */
@property (nonatomic, readonly, nullable) NSDate *markInDate;

/**
 *  The date corresponding to the mark out time, `nil` if no such relationship exists.
 */
@property (nonatomic, readonly, nullable) NSDate *markOutDate;

@end

NS_ASSUME_NONNULL_END
