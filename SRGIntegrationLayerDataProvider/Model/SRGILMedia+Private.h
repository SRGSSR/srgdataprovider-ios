//
//  SRGILVideo_Private.h
//  SRGPlayer
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRGILMedia.h"
#import "SRGILAssetSet.h"
#import "SRGILImage.h"
#import "SRGILPlaylist.h"
#import "SRGILSocialCounts.h"

@interface SRGILMedia ()

@property (nonatomic, strong) SRGILSocialCounts *socialCounts;

/**
 * Whether the video is a full length sequence
 */
@property (nonatomic, strong) NSNumber *fullLengthNumber;

/**
* The duration of the media, in seconds. Used for audio.
*/
@property (nonatomic, strong) NSNumber *assetDuration;

/**
 * Metadata information about the video
 */
@property (nonatomic, strong) NSArray *assetMetadatas;

/**
 * Asset set subtype (episode, trailer or livestream)
 * Optional field: is either filled in SRGILVideo or in SRGAsset.
 */
@property (nonatomic, assign) SRGILAssetSubSetType assetSetSubType;

@property (nonatomic) BOOL isLivestreamPlaylist;

- (SRGILPlaylistProtocol)playlistProtocolForURL:(NSURL *)URL;
- (SRGILPlaylistURLQuality)playlistURLQualityForURL:(NSURL *)URL;

/**
 * List of the playlist (i.e. URLs) of the video
 */
@property (nonatomic, strong) NSArray *playlists;

/**
 * Override of read-only public property position
 */
@property (nonatomic) NSUInteger position;

/**
 *  A flag indicating if the video *should* be geoblocked if played from an
 * unauthorized country.
 *
 * Is actually different from blockingReason, which indicates if the video "is" actually
 * blocked for geo reasons.
 */
@property (nonatomic) BOOL shouldBeGeoblocked;

/**
 * The famous flag indicatinjg whether this segment should be ... displayable in the segment list
 */
@property (nonatomic) BOOL displayable;

@end
