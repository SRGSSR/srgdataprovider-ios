//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of module services (e.g. events) supported by the data provider.
 */
@interface SRGDataProvider (ModuleServices)

/**
 *  List modules for a specific type (e.g. events).
 *
 *  @param moduleType A specific module type.
 */
- (SRGRequest *)modulesForVendor:(SRGVendor)vendor
                            type:(SRGModuleType)moduleType
             withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
