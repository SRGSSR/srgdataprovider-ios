//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILOngoingRequest+Private.h"

@interface SRGILOngoingRequest ()

@property (nonatomic) NSURLSessionTask *task;
@property (nonatomic) NSMutableDictionary *completionBlockDictionary;

@end

@implementation SRGILOngoingRequest

- (instancetype)initWithTask:(NSURLSessionTask *)task
{
    if (self = [super init]) {
        self.task = task;
        self.completionBlockDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)addCompletionBlock:(void (^)(id, NSError *))completionBlock
{
    NSParameterAssert(completionBlock);
    
    NSString *key = [NSUUID UUID].UUIDString;
    self.completionBlockDictionary[key] = [completionBlock copy];
    
    if (self.completionBlockDictionary.count == 1) {
        [self.task resume];
    }
    
    return key;
}

- (void)removeCompletionBlockWithKey:(NSString *)key
{
    [self.completionBlockDictionary removeObjectForKey:key];
    
    if (self.completionBlockDictionary.count == 0) {
        [self.task cancel];
    }
}

- (NSArray *)keys
{
    return [self.completionBlockDictionary allKeys];
}

- (NSArray *)completionBlocks
{
    return [self.completionBlockDictionary allValues];
}

- (BOOL)isEmpty
{
    return self.completionBlockDictionary.count == 0;
}

@end
