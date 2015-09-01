//
//  SRGILOngoingRequest+Private.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Samuel Defago on 28.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
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
