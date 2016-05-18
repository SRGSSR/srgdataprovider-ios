//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

typedef void(^SRGILOngoingRequestProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface SRGILOngoingRequest : NSObject

@property (nonatomic, readonly) NSURLSessionTask *task;

@property (nonatomic, readonly) NSArray *keys;
@property (nonatomic, readonly) NSArray *completionBlocks;

@property (nonatomic, copy) SRGILOngoingRequestProgressBlock progressBlock;

- (instancetype)initWithTask:(NSURLSessionTask *)task;
- (NSString *)addCompletionBlock:(void (^)(id, NSError *))completionBlock;
- (void)removeCompletionBlockWithKey:(NSString *)key;

@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

@end
