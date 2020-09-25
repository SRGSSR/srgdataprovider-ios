//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Artist information.
 */
@interface SRGArtist : SRGModel

/**
 *  Artist name.
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 *  Artist page URL.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
