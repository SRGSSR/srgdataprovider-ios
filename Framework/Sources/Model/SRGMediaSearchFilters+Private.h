//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSearchFilters.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for implementation purposes.
 */
@interface SRGMediaSearchFilters (Private)

/**
 *  URL query items corresponding to the search filters.
 */
@property (nonatomic, readonly) NSArray<NSURLQueryItem *> *queryItems;

@end

NS_ASSUME_NONNULL_END
