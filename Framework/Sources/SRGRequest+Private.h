//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGRequest (Private)

- (instancetype)initWithSessionTask:(NSURLSessionTask *)sessionTask;

@property (nonatomic, getter=isRunning) BOOL running;

@end

NS_ASSUME_NONNULL_END
