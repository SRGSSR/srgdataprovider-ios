//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"
#import "SRGMedia.h"
#import "SRGMediaParentMetadata.h"
#import "SRGMediaURN.h"
#import "SRGModel.h"
#import "SRGSegment.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Full information used when playing a media. A media composition provides the full playback context:
 *    - List of chapters and segments, and which one should be played first.
 *    - Complete media information.
 *    - Analytics information.
 */
@interface SRGMediaComposition : SRGModel <SRGMediaParentMetadata>

/**
 *  The URN of the chapter which should initially be played.
 *
 *  For convenient direct retrieval of the `SRGChapter` object, use the `mainChapter` property directly.
 */
@property (nonatomic, readonly) SRGMediaURN *chapterURN;

/**
 *  The URN of the segment which should initially be played.
 *
 *  For convenient direct retrieval of the `SRGSegment` object, use the `mainSegment` property directly.
 */
@property (nonatomic, readonly, nullable) SRGMediaURN *segmentURN;

/**
 *  The list of chapters available for the media.
 */
@property (nonatomic, readonly) NSArray<SRGChapter *> *chapters;

/**
 *  The list of analytics labels which should be supplied in SRG Analytics events
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *analyticsLabels;

@end

@interface SRGMediaComposition (Helpers)

/**
 *  The chapter which should be initially played.
 */
@property (nonatomic, readonly) SRGChapter *mainChapter;

/**
 *  The segment from the main chapter which should be initially played, if any.
 */
@property (nonatomic, readonly, nullable) SRGSegment *mainSegment;

/**
 *  Return the media object corresponding to the media composition full-length, if any.
 */
@property (nonatomic, readonly, nullable) SRGMedia *fullLengthMedia;

@end

@interface SRGMediaComposition (Generators)

/**
 *  Return the media corresponding to a subdivision (chapter or segment) belonging to the receiver.
 *
 *  @param division The subdivision which the media must be returned for. If the subdivision does not belong to the 
 *                  receiver, the method returns `nil`.
 */
- (nullable SRGMedia *)mediaForSubdivision:(SRGSubdivision *)subdivision;

/**
 *  Return the media composition corresponding to a subdivision (chapter or segment) belonging to the receiver.
 *
 *  @param division The subdivision which the media must be returned for. If the subdivision does not belong to the
 *                  receiver, the method returns `nil`.
 */
- (nullable SRGMediaComposition *)mediaCompositionForSubdivision:(SRGSubdivision *)subdivision;

@end

NS_ASSUME_NONNULL_END
