//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGSessionTaskQueue : NSObject

- (instancetype)initWithStateChangeBlock:(nullable void (^)(BOOL finished, NSError * _Nullable error))stateChangeBlock;

- (void)addSessionTask:(NSURLSessionTask *)sessionTask resume:(BOOL)resume;

- (void)resume;
- (void)cancel;

- (void)reportError:(nullable NSError *)error;

@property (nonatomic, readonly, getter=isFinished) BOOL finished;

@end

NS_ASSUME_NONNULL_END
