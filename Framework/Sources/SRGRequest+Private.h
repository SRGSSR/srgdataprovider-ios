//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SRGRequestCompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface SRGRequest (Private)

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionHandler:(SRGRequestCompletionHandler)completionHandler;

- (SRGRequest *)requestWithPage:(nullable SRGPage *)page session:(NSURLSession *)session;

@end

NS_ASSUME_NONNULL_END
