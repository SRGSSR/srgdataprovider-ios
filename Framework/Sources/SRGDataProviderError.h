//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Data provider error constants. More information is available from the `userInfo` associated with these errors.
 */
typedef NS_ENUM(NSInteger, SRGDataProviderErrorCode) {
    /**
     *  An HTTP error has been encountered. The HTTP status code is available from the user info under the
     *  `SRGDataProviderHTTPStatusCodeKey` key (as an `NSNumber`).
     */
    SRGDataProviderErrorHTTP,
    /**
     *  A redirect was encountered. This is e.g. often encountered on public wifis with a login page. Use the 
     *  `SRGDataProviderRedirectionURLKey` info key to retrieve the redirection URL (as an `NSURL`).
     */
    SRGDataProviderErrorRedirect,
    /**
     *  The data which was received is invalid.
     */
    SRGDataProviderErrorCodeInvalidData,
    /**
     *  Several errors have been encountered. Use the `SRGDataProviderErrorsKey` user info key to retrieve the 
     *  error list (as an `NSArray<NSError *>`).
     */
    SRGDataProviderErrorMultiple,
    /**
     *  The data was not found.
     */
    SRGDataProviderErrorNotFound
};

/**
 *  Common domain for data provider errors.
 */
OBJC_EXPORT NSString * const SRGDataProviderErrorDomain;

/**
 *  Error user information keys, @see `SRGDataProviderErrorCode`.
 */
OBJC_EXPORT NSString * const SRGDataProviderHTTPStatusCodeKey;
OBJC_EXPORT NSString * const SRGDataProviderRedirectionURLKey;
OBJC_EXPORT NSString * const SRGDataProviderErrorsKey;

NS_ASSUME_NONNULL_END
