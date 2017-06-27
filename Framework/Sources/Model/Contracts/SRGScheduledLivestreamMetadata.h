//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for scheduled livestream information.
 */
@protocol SRGScheduledLivestreamMetadata <NSObject>

/**
 *  The date at which the pre-trailer starts.
 */
@property (nonatomic, readonly, nullable) NSDate *preTrailerStartDate;

/**
 *  The date at which the post-trailer stops.
 */
@property (nonatomic, readonly, nullable) NSDate *postTrailerEndDate;

@end

NS_ASSUME_NONNULL_END
