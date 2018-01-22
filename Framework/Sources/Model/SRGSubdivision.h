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
 *  Abstract base class representing a media subdivision (part of a media).
 */
@interface SRGSubdivision : SRGModel <SRGMediaMetadata>

/**
 *  The URN of the full length to which the subdivision belongs, if any.
 */
@property (nonatomic, readonly, nullable) SRGMediaURN *fullLengthURN;

/**
 *  Return whether the subdivision must be hidden client-side.
 */
@property (nonatomic, readonly, getter=isHidden) BOOL hidden;

/**
 *  An opaque event information to be sent when liking the represented subdivision.
 */
@property (nonatomic, readonly, copy, nullable) NSString *event;

/**
 *  The list of labels which should be supplied in SRG Analytics player events.
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *analyticsLabels;

/**
 *  The list of comScore labels which should be supplied in SRG Analytics player events.
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;

/**
 *  The list of available subtitles.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSubtitle *> *subtitles;

@end

@interface SRGSubdivision (Subtitles)

/**
 *  The recommended subtitle format to use. Might return `SRGSubtitleFormatNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGSubtitleFormat recommendedSubtitleFormat;

/**
 *  Return subtitles matching the specified format.
 */
- (nullable NSArray<SRGSubtitle *> *)subtitlesWithFormat:(SRGSubtitleFormat)format;

@end

NS_ASSUME_NONNULL_END
