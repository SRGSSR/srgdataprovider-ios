//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSearchSettings.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for implementation purposes.
 */
@interface SRGMediaSearchSettings (Private)

/**
 *  URL query items corresponding to the search settings, for the specified vendor.
 */
- (NSArray<NSURLQueryItem *> *)queryItemsForVendor:(SRGVendor)vendor;

@end

NS_ASSUME_NONNULL_END
