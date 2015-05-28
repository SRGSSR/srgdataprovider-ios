//
//  SRGILOngoingRequest+Private.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Samuel Defago on 28.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILOngoingRequest+Private.h"

@interface SRGILOngoingRequest ()

@property (nonatomic) NSOperation *operation;
@property (nonatomic) NSMutableArray *mutableCompletionBlocks;

@end

@implementation SRGILOngoingRequest

- (instancetype)initWithOperation:(NSOperation *)operation
{
    if (self = [super init]) {
        self.operation = operation;
        self.mutableCompletionBlocks = [NSMutableArray array];
    }
    return self;
}

- (void)addCompletionBlock:(void (^)(SRGILMedia *, NSError *))completionBlock
{
    NSParameterAssert(completionBlock);
    
    [self.mutableCompletionBlocks addObject:[completionBlock copy]];
}

- (NSArray *)completionBlocks
{
    return [NSArray arrayWithArray:self.mutableCompletionBlocks];
}

@end
