//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGAlbum.h"
#import "SRGArtist.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Song information.
 */
@interface SRGSong : SRGModel

/**
 *  Song title.
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  Date at which the song is played.
 */
@property (nonatomic, readonly) NSDate *date;

/**
 * The duration in milliseconds.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 *  Return `YES` iff the song is currently being played.
 */
@property (nonatomic, readonly, getter=isPlaying) BOOL playing;

/**
 *  Artist information.
 */
@property (nonatomic, readonly) SRGArtist *artist;

/**
 *  Album information.
 */
@property (nonatomic, readonly) SRGAlbum *album;

@end

NS_ASSUME_NONNULL_END
