//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"
#import "SRGILAnalyticsExtendedData.h"

@class SRGILAsset;
@class SRGILAssetSet;
@class SRGILImage;
@class SRGILPlaylist;
@class SRGILSocialCounts;

/**
 * SRGILMedia is the main data-model class of the SRG Player framework.
 */
@interface SRGILMedia : SRGILModelObject

/**
 * The media creation date
 */
@property (nonatomic, readonly, strong) NSDate *creationDate;


// -- Playback Properties

/**
 *  A flag indicating whether the media is a "fullLength" content media or not.
 */
@property (nonatomic, readonly, assign, getter=isFullLength) BOOL fullLength;

/**
 * Optional: Position is the stream (when it has to be ordered, live streams for instance)
 */
@property (nonatomic, readonly) NSUInteger orderPosition;

/**
 * The timestamp at which the media begins, in seconds. Its value is 0 if the media is a Live stream.
 */
@property (nonatomic, readonly) NSTimeInterval markIn;
@property (nonatomic, readonly) NSInteger markInInMillisecond;

/**
 * The timestamp at which the media ends, in seconds. Its value is 0 if the media is a Live stream.
 */
@property (nonatomic, readonly) NSTimeInterval markOut;
@property (nonatomic, readonly) NSInteger markOutInMillisecond;

/**
 * The media duration, in seconds. Its value is 0 if the media is a Live stream.
 */
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSInteger durationInMillisecond;


// -- Assets Metadatas & Co

/**
 * Metadata information about the video
 */
@property (nonatomic, strong) NSArray *assetMetadatas;

/**
 * Related asset (e.g. broadcast information)
 */
@property (nonatomic, strong) SRGILAssetSet *assetSet;

/**
 * Related image
 */
@property (nonatomic, strong) SRGILImage *image;

/**
 *  Complementary analytics data.
 */
@property(nonatomic, readonly) SRGILAnalyticsExtendedData *analyticsData;


// -- Children

/**
 * Array of playlists (i.e. URLs) of the video
 */
@property (nonatomic, strong) NSArray *playlists;

/**
 * Array of downloads (i.e. URLs) of the video
 */
@property (nonatomic, strong) NSArray *downloads;



// -- Flags

/**
 * A flag indicating whether the media is blocked.
 */
@property (nonatomic, assign, readonly) SRGILMediaBlockingReason blockingReason;

/**
 * A flag indicating if the media *should* be geoblocked if played from an unauthorized country.
 * Is actually different from blockingReason, which indicates if the media "is" actually blocked for geo reasons.
 */
@property (nonatomic, assign, readonly) BOOL shouldBeGeoblocked;

/**
 * A flag indicating whether this media is part of a LiveStream playlist
 */
@property (nonatomic, assign, readonly) BOOL isLivestreamPlaylist;

/**
 * A flag indicating whether this media, if treated as a segment, should be displayed.
 */
@property (nonatomic, assign, readonly) BOOL displayable;

/**
 * Asset set subtype (episode, trailer or livestream)
 * Optional field: is either filled in SRGILVideo or in SRGAsset.
 */
@property (nonatomic, assign, readonly) SRGILAssetSubSetType assetSetSubType;

/**
 * Array of social counts of the video
 */
@property (nonatomic, strong, readonly) SRGILSocialCounts *socialCounts;

/**
 *  The trending picks contributor.
 */
@property (nonatomic, assign, readonly) SRGILMediaTrendContributor trendingContributor;


// --- Convenience Computed Methods

/**
 *  The media type
 */
- (SRGILMediaType)type;

/**
 *  Media title
 */
- (NSString *)title;

/**
 * A flag indicating whether the media is a live stream?
 */
- (BOOL)isLiveStream;

/**
 * A flag indicating whether the media is blocked.
 */
- (BOOL)isBlocked;

/**
 *  The number of time this media has been 'viewed'. Computed from the Social Counts.
 */
- (NSInteger)viewCount;

/**
 * A flag indicating whether the media is part of a live stream playlist.
 */
- (BOOL)isLivestreamPlaylist;

/**
 * The URL of the content, according to current state of network. Must be overriden by subclass.
 */
- (NSURL *)defaultContentURL;

/**
 *  Easily find the content URL for a given protocol and a given quality.
 *
 *  @param playlistProtocol The protocol
 *  @param quality          The quality
 *
 *  @return The URL.
 */
- (NSURL *)contentURLForPlaylistWithProtocol:(enum SRGILPlaylistProtocol)playlistProtocol withQuality:(SRGILPlaylistURLQuality)quality;

/**
 *  Finding the playlist for the given URL
 *
 *  @param URL The URL
 *
 *  @return The playlist protocol
 */
- (SRGILPlaylistProtocol)playlistProtocolForURL:(NSURL *)URL;

/**
 *  The playlist quality for a given URL
 *
 *  @param URL The URL
 *
 *  @return The playlist quality
 */
- (SRGILPlaylistURLQuality)playlistURLQualityForURL:(NSURL *)URL;

/**
 *  The segmentation for a given URL
 *
 *  @param URL The URL
 *
 *  @return The playlist segmnentation.
 */
- (SRGILPlaylistSegmentation)segmentationForURL:(NSURL *)URL;

/**
 *  Comparison of SRGILMedia instance according to the time of their markIn time.
 *
 *  @param other Another instance to be compared with.
 *
 *  @return NSOrderedSame if other.markIn > self.markIn, etc.
 */
- (NSComparisonResult)compareMarkInTimes:(SRGILMedia *)other;



// -- Segments


/**
 *  The parent of the media. Nil in case of fullLength. Placeholder set when requesting segments below.
 */
@property (nonatomic, weak) SRGILMedia *parent;

/**
 *  For some medias, it is possible to access individual segments. Here is returned the complete
 *  array of segments, whatever their subtype.
 *
 *  @return An array of SRGILMedia instances containing all the information for playing a segment.
 */
- (NSArray *)segments;

/**
 *  While the above methods -[segments] filters out the possible presence of a full length, this ones does not
 *  apply any filter whatsoever, and returns the raw list of medias as provided by the IL.
 *
 *  @return An array of SRGILMedia instances.
 */
- (NSArray *)allMedias;






@end


