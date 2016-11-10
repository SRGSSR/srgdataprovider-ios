//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"
#import "SRGMediaParentMetadata.h"
#import "SRGChapter.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Full information used when playing a media. A media composition provides the full playback context:
 *    - list of chapters and segments, and which one should be played first
 *    - complete media information
 *    - analytics information
 */
@interface SRGMediaComposition : MTLModel <SRGMediaParentMetadata, MTLJSONSerializing>

/**
 *  The URN of the chapter which should initially be played
 *
 *  For convenient direct retrieval of the `SRGChapter` object, use the `mainChapter` property directly
 */
@property (nonatomic, readonly, copy) NSString *chapterURN;

/**
 *  The URN of the segment which should initially be played
 *
 *  For convenient direct retrieval of the `SRGSegment` object, use the `mainSegment` property directly
 */
@property (nonatomic, readonly, copy, nullable) NSString *segmentURN;

/**
 *  The list of chapters available for the media
 */
@property (nonatomic, readonly) NSArray<SRGChapter *> *chapters;

/**
 *  The list of analytics labels which should be supplied in SRG Analytics events
 *  (https://github.com/SRGSSR/srganalytics-ios)
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *analyticsLabels;

/**
 *  An opaque event information to be sent when liking an event
 */
@property (nonatomic, readonly, copy, nullable) NSString *event;

@end

@interface SRGMediaComposition (Helpers)

/**
 *  The chapter which should be initially played
 */
@property (nonatomic, readonly) SRGChapter *mainChapter;

/**
 *  The segment from the main chapter which should be initially played
 */
@property (nonatomic, readonly, nullable) SRGSegment *mainSegment;

@end

@interface SRGMediaComposition (Generators)

/**
 *  Return the media corresponding to a segment belonging to the receiver.
 *
 *  @param segment The segment which the media must be returned for. If the segment does not belong to the receiver, 
 *                 the method returns `nil`
 *
 *  @discussion Since `SRGChapter` is a subclass of `SRGSegment`, this method works for chapters as well
 */
- (nullable SRGMedia *)mediaForSegment:(SRGSegment *)segment;

/**
 *  Return the media corresponding to a chapter belonging to the receiver.
 *
 *  @param chapter The chapter which the media must be returned for. If the chapter does not belong to the receiver,
 *                 the method returns `nil`
 */
- (nullable SRGMedia *)mediaForChapter:(SRGChapter *)chapter;

/**
 *  Return the media composition corresponding to a segment belonging to the receiver.
 *
 *  @param segment The segment which the composition must be generated for. If the specified segment does not belong 
 *                 to the media composition, the method returns `nil`
 */
- (nullable SRGMediaComposition *)mediaCompositionForSegment:(SRGSegment *)segment;

/**
 *  Return the media composition corresponding to a chapter belonging to the receiver.
 *
 *  @param chapter The chapter which the composition must be generated for. If the specified chapter does not belong 
 *                 to the media composition, the method returns `nil`
 *
 *  @discussion Since `SRGChapter` is a subclass of `SRGSegment`, this method works for chapters as well
 */
- (nullable SRGMediaComposition *)mediaCompositionForChapter:(SRGChapter *)chapter;

@end

NS_ASSUME_NONNULL_END
