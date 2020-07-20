//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBroadcastInformation.h"
#import "SRGIdentifierMetadata.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for show identification.
 */
@protocol SRGShowIdentifierMetadata <SRGIdentifierMetadata>

/**
 *  The show transmission.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

/**
 *  Broadcast information associated with the show.
 */
@property (nonatomic, readonly, nullable) SRGBroadcastInformation *broadcastInformation;

@end

NS_ASSUME_NONNULL_END
