//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBroadcastInformation.h"
#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for show identification.
 */
@protocol SRGShowIdentifierMetadata <NSObject>

/**
 *  The unique show identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The Uniform Resource Name identifying the show.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The show transmission.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

/**
 *  The business unit which the show belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  Broadcast information associated with the show.
 */
@property (nonatomic, readonly, nullable) SRGBroadcastInformation *broadcastInformation;

@end

NS_ASSUME_NONNULL_END
