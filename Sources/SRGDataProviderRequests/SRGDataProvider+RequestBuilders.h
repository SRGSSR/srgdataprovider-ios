//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Return a date string representation suitable for service parameters.
 */
OBJC_EXPORT NSString *SRGStringFromDate(NSDate *date);

/**
 *  Return the resource path component corresponding to a vendor.
 */
OBJC_EXPORT NSString *SRGPathComponentForVendor(SRGVendor vendor);

/**
 *  Return the resource path component corresponding to a module type.
 */
OBJC_EXPORT NSString *SRGPathComponentForModuleType(SRGModuleType moduleType);

/**
 *  Methods for internal request building purposes.
 */
@interface SRGDataProvider (RequestBuilders)

/**
 *  Return a properly configured URL requestwith the specified resource path and query items.
 */
- (NSURLRequest *)URLRequestForResourcePath:(NSString *)resourcePath withQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems;

@end

NS_ASSUME_NONNULL_END
