//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSearchSettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for implementation purposes.
 */
@interface SRGMediaSearchSettings (Private)

/**
 *  URL query items corresponding to the search settings.
 */
@property (nonatomic, readonly) NSArray<NSURLQueryItem *> *queryItems;

@end

NS_ASSUME_NONNULL_END
