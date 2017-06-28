//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGMediaMetadata.h"
#import "SRGMediaURN.h"
#import "SRGSubtitle.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Abstract base class for media representations.
 */
@interface SRGMediaRepresentation : SRGModel <SRGMediaMetadata>

/**
 *  The URN of the full length to which the representation belongs, if any.
 */
@property (nonatomic, readonly, nullable) SRGMediaURN *fullLengthURN;

/**
 *  An index specifying the order of sibling representations in collections.
 */
@property (nonatomic, readonly) NSInteger position;

/**
 *  The time at which the represented media starts, in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval markIn;

/**
 *  The time at which the represented media ends, in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval markOut;

/**
 *  An opaque event information to be sent when liking the represented media.
 */
@property (nonatomic, readonly, copy, nullable) NSString *event;

/**
 *  The list of analytics labels which should be supplied in SRG Analytics events
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *analyticsLabels;

/**
 *  The list of available subtitles.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSubtitle *> *subtitles;

@end

NS_ASSUME_NONNULL_END
