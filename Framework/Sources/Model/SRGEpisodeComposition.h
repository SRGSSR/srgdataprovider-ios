//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChannel.h"
#import "SRGEpisode.h"
#import "SRGModel.h"
#import "SRGShow.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of related episodes
 */
@interface SRGEpisodeComposition : SRGModel

/**
 *  The channel which the episodes belong to
 */
@property (nonatomic, readonly, nullable) SRGChannel *channel;

/**
 *  The show which the episodes belong to
 */
@property (nonatomic, readonly) SRGShow *show;

/**
 *  The list of episodes
 */
@property (nonatomic, readonly, nullable) NSArray<SRGEpisode *> *episodes;

@end

NS_ASSUME_NONNULL_END
