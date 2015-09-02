//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILOngoingRequest+Private.h"

@interface SRGILOngoingRequest ()

@property (nonatomic) NSURLSessionTask *task;
@property (nonatomic) NSMutableArray *mutableCompletionBlocks;

@end

@implementation SRGILOngoingRequest

- (instancetype)initWithTask:(NSURLSessionTask *)task
{
    if (self = [super init]) {
        self.task = task;
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
