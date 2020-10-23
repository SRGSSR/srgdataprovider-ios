//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Broadcast information.
 */
@interface SRGBroadcastInformation : SRGModel

/**
 *  An information message.
 */
@property (nonatomic, readonly, copy) NSString *message;

/**
 *  The date at which the information has been made available.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The date at which the information will be removed.
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 *  A URL to an associated web page.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
