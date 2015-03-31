//
//  SRGmedia.h
//  SRGPlayer
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"
#import "SRGILAnalyticsExtendedData.h"

/**
 * SRGmedia is the main data-model class of the SRG Player framework.
 */
@interface SRGILMedia : SRGILModelObject

/**
 *  The media type
 */
+ (SRGILMediaType)type;

/**
 *  The title of the media.
 */
@property (nonatomic, readonly, strong) NSString *title;

/**
 * The name of the broadcast or rubric the media belongs to
 */
@property (nonatomic, readonly, strong) NSString *parentTitle;

/**
 *  The complete description text of the media.
 */
@property (nonatomic, readonly, strong) NSString *mediaDescription;

/**
 *  The number of time this media has been 'viewed'.
 */
- (NSInteger)viewCount;

/**
 * The media creation date
 */
@property (nonatomic, readonly, strong) NSDate *creationDate;

/**
 *  A flag indicating whether the media is a "fullLength" content media or not.
 */
@property (nonatomic, readonly, assign, getter=isFullLength) BOOL fullLength;

/**
 * A flag indicating whether the media is a live stream?
 */
@property (nonatomic, readonly, assign) BOOL isLiveStream;

/**
 * Optional: Position is the stream (when it has to be ordered, live streams for instance)
 */
@property (nonatomic, readonly) NSUInteger orderPosition;

/**
 * A flag indicating whether the media is blocked.
 */
@property (nonatomic, readonly, getter=isBlocked) BOOL blocked;

/**
 * A flag indicating whether the media is blocked.
 */
@property (nonatomic, readonly, assign) SRGILMediaBlockingReason blockingReason;

/**
 *  A flag indicating if the media *should* be geoblocked if played from an
 * unauthorized country.
 *
 * Is actually different from blockingReason, which indicates if the media "is" actually
 * blocked for geo reasons.
 */
@property (nonatomic, readonly) BOOL shouldBeGeoblocked;

/**
 * A flag indicating whether this media, if treated as a segment, should be displayed.
 */
@property (nonatomic,readonly) BOOL displayable;

/**
 * The timestamp at which the media begins, in seconds. Its value is 0 if the media is a Live stream.
 */
@property (nonatomic, readonly, assign) NSTimeInterval markIn;

/**
 * The timestamp at which the media ends, in seconds. Its value is 0 if the media is a Live stream.
 */
@property (nonatomic, readonly, assign) NSTimeInterval markOut;

/**
 * The media duration, in milliseconds. Its value is 0 if the media is a Live stream.
 */
@property (nonatomic, readonly, assign) NSTimeInterval duration;

/**
 *  If the media has segments, return the full length (1st segment) duration.
 *  Otherwise return duration.
 */
@property (nonatomic, readonly, assign) NSTimeInterval fullLengthDuration;

/**
 *  Complemetary analytics data. 
 *  At the moment:
 *  - for RSI and RTS (but will generalized)
 *  - video only
 */
@property(nonatomic,readonly) SRGILAnalyticsExtendedData *analyticsData;

/**
 *  For some medias, it is possible to access individual segments. Here is returned the complete 
 *  array of segments, whatever their subtype.
 *
 *  @return An array of SRGmedia instances containing all the information for playing a segment.
 */
- (NSArray *)segments;

/**
 *  Comparison of SRGmedia instance according to the time of their markIn time.
 *
 *  @param other Another instance to be compared with.
 *
 *  @return NSOrderedSame if other.markIn > self.markIn, etc.
 */
- (NSComparisonResult)compareMarkInTimes:(SRGILMedia *)other;

@end


