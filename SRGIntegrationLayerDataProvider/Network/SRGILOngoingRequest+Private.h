//
//  SRGILOngoingRequest+Private.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Samuel Defago on 28.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRGILMedia;

@interface SRGILOngoingRequest : NSObject

- (instancetype)initWithOperation:(NSOperation *)operation;

@property (nonatomic, readonly) NSOperation *operation;
@property (nonatomic, readonly) NSArray *completionBlocks;

- (void)addCompletionBlock:(void (^)(SRGILMedia *, NSError *))completionBlock;

@end
