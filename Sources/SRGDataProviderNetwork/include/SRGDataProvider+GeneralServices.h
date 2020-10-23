//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  General services supported by the data provider.
 */
@interface SRGDataProvider (GeneralServices)

/**
 *  Retrieve a message from the service about its status, if there is currently one. If none is available, the
 *  call ends with an HTTP error.
 */
- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor
                    withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
