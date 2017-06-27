//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for internal use.
 *
 *  TODO: This class is required for implementation of image overrides in search results. Since the image URL is
 *        stored in the `SRGSearchResult` abstract class, but uids (used to perform override lookup) in concrete subclasses,
 *        we need a way to provide the internal image URL information to subclasses. This requirement would disappear
 *        if image overrides were not needed, and this private category should then simply be dropped.
 */
@interface SRGSearchResult (Private)

/**
 *  The raw image URL associated with a search result.
 */
@property (nonatomic, readonly) NSURL *imageURL;

@end

NS_ASSUME_NONNULL_END
