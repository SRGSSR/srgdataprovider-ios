//
//  Copyright (c) RTS. All rights reserved.
//
//  Licence information is available from the LICENCE file.
//

#import <UIKit/UIKit.h>

#import <SRGMediaPlayer/RTSMediaPlayback.h>
#import <SRGMediaPlayer/RTSMediaPlayerConstants.h>
#import <SRGMediaPlayer/RTSMediaSegmentsDataSource.h>


@class RTSMediaPlayerController;
@protocol RTSMediaSegment;

@interface RTSMediaSegmentsController : NSObject <RTSMediaPlayback>

/**
 *  The player controller associated with the segments controller.
 */
@property(nonatomic, weak) IBOutlet RTSMediaPlayerController *playerController;

/**
 *  The data source of the segments controller.
 */
@property(nonatomic, weak) IBOutlet id<RTSMediaSegmentsDataSource> dataSource;

/**
 *  The full length "segment"/media.
 */
@property(nonatomic, strong, readonly) id<RTSMediaSegment> fullLengthSegment;

/**
 *  Reload segments data for given media identifier.
 *
 *  @param identifier        The media identifier
 *  @param completionHandler The completion handler.
 */
- (void)reloadSegmentsForIdentifier:(NSString *)identifier completionHandler:(void (^)(NSError *error))completionHandler;

/**
 *  The count of segments.
 *
 *  @return An unsigned integer indicating the count of segments.
 */
- (NSUInteger)countOfSegments;

/**
 *  The segments
 *
 *  @return A an array containing the segments.
 */
- (NSArray *)segments;

/**
 *  The count of visible segments
 *
 *  @return An unsigned integer indicating the count of visible segments.
 */
- (NSUInteger)countOfVisibleSegments;

/**
 *  The visible segments
 *
 *  @return A an array containing the data sources of each episodes.
 */
- (NSArray *)visibleSegments;

/**
 *  For each segment index, one must have a given 'visible segment' index.
 *
 *  @param segmentIndex The index of the segment.
 *
 *  @return The index of the episodes corresponding to the provided segment index.
 */
- (NSUInteger)indexOfVisibleSegmentForSegmentIndex:(NSUInteger)segmentIndex;

/**
 *  Return the index of the visible segment for a given time. Returns NSNotFound if time corresponds to no visible segment.
 *
 *  @param time The time to consider
 *
 *  @return The index of the visible segment for the given time, if any.
 */
- (NSUInteger)indexOfVisibleSegmentForTime:(CMTime)time;

/**
 *  Check whether the segment at the given index is blocked.
 *
 *  @param index The index of the segment to be checked.
 *
 *  @return YES if the segment is blocked.
 */
- (BOOL)isSegmentBlockedAtIndex:(NSUInteger)index;
- (BOOL)isVisibleSegmentBlockedAtIndex:(NSUInteger)index;

/**
 *  When hitting a blocked segment, one must find when exactly restarting the video, if possible. Hence,
 *  given the actual blocked segment at index, we look for the last of the next segments that is also blocked.
 *  Small gaps in between segments (say below < 0.2 seconds) are considered as non-playable content, and
 *  the two segments considered as contiguous.
 *
 *  @param index          The index of the last contiguous segment that is blocked. It can be equal to the current index.
 *  @param flexibilityGap A small gap (say ~ 0.1 sec) used for some flexbility for checking contiguity between segment times.
 *
 *  @return The index of the last contiguous segment. Can be equal to index. Playback should restart at end of the visible 
 *  segment at that index. If there is no more segments and no more playable content, returns NSNotFound;
 */
- (NSUInteger)indexOfLastContiguousBlockedSegmentAfterIndex:(NSUInteger)index withFlexibilityGap:(NSTimeInterval)flexibilityGap;

/**
 *  The index of the current visible segment in which the playback head is located.
 *
 *  @return The index of the visible segment. Returns -1 if the position corresponds to no segments.
 */
- (NSInteger)currentVisibleSegmentIndex;

/**
 *  The index of the current segment in which the playback head is located.
 *
 *  @return The index of the segment. Returns -1 if the position corresponds to no segments.
 */
- (NSInteger)currentSegmentIndex;

/**
 *  Asks the segments controller to seek to the visible segment at the given index. Does nothing if the segment
 *  is blocked.
 *
 *  @param index The index of the visible segment to seek to.
 */
- (void)playVisibleSegmentAtIndex:(NSUInteger)index;

@end
