//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Album information.
 */
@interface SRGAlbum : SRGModel

/**
 *  Album name.
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 *  Album small cover image URL.
 */
@property (nonatomic, readonly, nullable) NSURL *smallCoverImageURL;

/**
 *  Album large cover image URL.
 */
@property (nonatomic, readonly, nullable) NSURL *largeCoverImageURL;

@end

NS_ASSUME_NONNULL_END
