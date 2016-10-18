//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChannel.h"
#import "SRGEpisode.h"
#import "SRGShow.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for media parent informations
 */
@protocol SRGMediaParentMetadata <NSObject>

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
