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

@interface SRGMedia : MTLModel <SRGMediaMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, nullable) SRGChannel *channel;
@property (nonatomic, readonly, nullable) SRGEpisode *episode;
@property (nonatomic, readonly, nullable) SRGShow *show;

@end

NS_ASSUME_NONNULL_END
