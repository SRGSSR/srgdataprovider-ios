//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"
#import "SRGMediaURN.h"
#import "SRGModel.h"
#import "SRGSubtitle.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A section is a logical media subdivision. It can correspond to an actual media (@see `SRGChapter`) or to a subset
 *  of a media (logical segmentation)
 */
@interface SRGSegment : SRGModel <SRGMediaMetadata>

/**
 *  The URN of the full length segment to which the segment belongs, if any
 */
@property (nonatomic, readonly, nullable) SRGMediaURN *fullLengthURN;

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
 *  An opaque event information to be sent when liking an event
 */
@property (nonatomic, readonly, copy, nullable) NSString *event;

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
