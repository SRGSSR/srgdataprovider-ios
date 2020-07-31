//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSURLRequest *SRGDataProviderRequest(NSURL *serviceURL, NSString *resourcePath, NSArray<NSURLQueryItem *> * _Nullable queryItems, NSDictionary<NSString *, NSString *> * _Nullable headers, NSDictionary<NSString *, NSString *> * _Nullable parameters);
OBJC_EXPORT NSArray * _Nullable SRGDataProviderParseObjects(NSData *data, NSString *rootKey, Class modelClass, NSError * __autoreleasing *pError);
OBJC_EXPORT NSString *SRGPathComponentForVendor(SRGVendor vendor);

NS_ASSUME_NONNULL_END
