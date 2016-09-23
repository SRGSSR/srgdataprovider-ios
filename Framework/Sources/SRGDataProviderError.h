//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRGDataProviderErrorCode) {
    SRGDataProviderErrorHTTP,
    SRGDataProviderErrorRedirect,                   // Use the SRGDataProviderRedirectionURLKey info key to retrieve the redirection URL (NSURL)
    SRGDataProviderErrorCodeInvalidData,
    SRGDataProviderErrorMultiple                    // Use the SRGDataProviderErrorsKey info key to retrieve the error list (NSArray<NSError *>)
};

OBJC_EXPORT NSString * const SRGDataProviderErrorDomain;

OBJC_EXPORT NSString * const SRGDataProviderRedirectionURLKey;
OBJC_EXPORT NSString * const SRGDataProviderErrorsKey;

NS_ASSUME_NONNULL_END
