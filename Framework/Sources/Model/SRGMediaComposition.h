//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChannel.h"
#import "SRGChapter.h"
#import "SRGEpisode.h"
#import "SRGShow.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Full information used when playing a media. A media composition provides the full playback context:
 *    - list of chapters and segments, and which one should be played first
 *    - complete media information
 *    - analytics information
 */
@interface SRGMediaComposition : MTLModel <MTLJSONSerializing>

/**
 *  The URN of the chapter which should initially be played
 *
 *  For convenient direct retrieval of the `SRGChapter` object, use the `mainChapter` property directly
 */
@property (nonatomic, readonly, copy) NSString *chapterURN;

/**
 *  The URN of the segment which should initially be played
 *
 *  For convenient direct retrieval of the `SRGSegment` object, use the `mainChapter` property directly
 */
@property (nonatomic, readonly, copy) NSString *segmentURN;

/**
 *  The channel the media belongs to
 */
@property (nonatomic, readonly, nullable) SRGChannel *channel;

/**
 *  The episode the media belongs to
 */
@property (nonatomic, readonly, nullable) SRGEpisode *episode;

/**
 *  The show the media belongs to
 */
@property (nonatomic, readonly, nullable) SRGShow *show;

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
@property (nonatomic, readonly) SRGSegment *mainSegment;

@end

NS_ASSUME_NONNULL_END
