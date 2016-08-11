//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSURLRequest *SRGDataProviderRequestWithError(NSError *error);

@interface NSURLSession (SRGDataProvider)

- (SRGRequest *)srg_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
- (SRGRequest *)srg_taskForError:(NSError *)error withCompletionHandler:(void (^)(NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
