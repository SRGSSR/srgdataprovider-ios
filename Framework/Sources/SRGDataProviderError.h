//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRGDataProviderErrorCode) {
    SRGDataProviderErrorHTTP,
    SRGDataProviderErrorCodeInvalidRequest,
    SRGDataProviderErrorCodeInvalidData,
    SRGDataProviderErrorMultiple            // Use the SRGDataProviderErrorsKey info key to retrieve the error list
};

OBJC_EXPORT NSString * const SRGDataProviderErrorDomain;

OBJC_EXPORT NSString * const SRGDataProviderErrorsKey;

NS_ASSUME_NONNULL_END
