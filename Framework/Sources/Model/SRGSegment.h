//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"
#import "SRGSubtitle.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A section is a logical media subdivision. It can correspond to an actual media (@see `SRGChapter`) or to a subset
 *  of a media (logical segmentation)
 */
@interface SRGSegment : MTLModel <SRGMediaMetadata, MTLJSONSerializing>

/**
 *  The URN of the full length segment to which the segment belongs, if any
 */
@property (nonatomic, copy, readonly, nullable) NSString *fullLengthURN;

/**
 *  An index specifying the order of sibling segments in collections
 */
@property (nonatomic, readonly) NSInteger position;

/**
 *  The time at which the segment starts, in milliseconds
 */
@property (nonatomic, readonly) NSTimeInterval markIn;

/**
 *  The time at which the segment ends, in milliseconds
 */
@property (nonatomic, readonly) NSTimeInterval markOut;

/**
 *  Return whether segment playback should be blocked client-side. If `SRGBlockingReasonNone`, the segment can be
 *  freely played
 */
@property (nonatomic, readonly) SRGBlockingReason blockingReason;

/**
 *  The list of analytics labels which should be supplied in SRG Analytics events
 *  (https://github.com/SRGSSR/srganalytics-ios)
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *analyticsLabels;

/**
 *  The list of available subtitles
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSubtitle *> *subtitles;

@end

NS_ASSUME_NONNULL_END
