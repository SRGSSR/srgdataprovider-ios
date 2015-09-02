//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

@class SRGILMedia;

typedef void(^SRGILOngoingRequestProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface SRGILOngoingRequest : NSObject

@property (nonatomic, readonly) NSURLSessionTask *task;
@property (nonatomic, readonly) NSArray *completionBlocks;
@property (nonatomic, copy) SRGILOngoingRequestProgressBlock progressBlock;

- (instancetype)initWithTask:(NSURLSessionTask *)task;
- (void)addCompletionBlock:(void (^)(SRGILMedia *, NSError *))completionBlock;

@end
