//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"

#import "SRGChannel.h"
#import "SRGEpisode.h"
#import "SRGShow.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A media (audio or video). This is a lightweight representation (which does not contain the URLs to be played,
 *  most notably). For complete information, an `SRGMediaComposition` must be requested
 */
@interface SRGMedia : MTLModel <SRGMediaMetadata, MTLJSONSerializing>

/**
 *  The channel which the media belongs to
 */
@property (nonatomic, readonly, nullable) SRGChannel *channel;

/**
 *  The episode which the media belongs to
 */
@property (nonatomic, readonly, nullable) SRGEpisode *episode;

/**
 *  The show which the media belongs to
 */
@property (nonatomic, readonly, nullable) SRGShow *show;

@end

NS_ASSUME_NONNULL_END
