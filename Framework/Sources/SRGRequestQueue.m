//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequestQueue.h"

#import "SRGDataProviderError.h"

static void *s_kvoContext = &s_kvoContext;

@interface SRGRequestQueue () {
@private
    BOOL _wasFinished;
}

@property (nonatomic) NSMutableArray<SRGRequest *> *requests;
@property (nonatomic, copy) void (^stateChangeBlock)(BOOL running, NSError *error);
@property (nonatomic) NSMutableArray<NSError *> *errors;

@end

@implementation SRGRequestQueue

- (instancetype)initWithStateChangeBlock:(void (^)(BOOL, NSError *))stateChangeBlock
{
    if (self = [super init]) {
        self.requests = [NSMutableArray array];
        self.errors = [NSMutableArray array];
        self.stateChangeBlock = stateChangeBlock;
        _wasFinished = YES;         // No task at creation, considered as finished
    }
    return self;
}

- (instancetype)init
{
    return [self initWithStateChangeBlock:nil];
}

- (void)dealloc
{
    for (SRGRequest *request in self.requests) {
        [request removeObserver:self forKeyPath:@"running" context:s_kvoContext];
    }
    [self checkStateChange];
}

- (void)addRequest:(SRGRequest *)request resume:(BOOL)resume
{
    [request addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:s_kvoContext];
    [self.requests addObject:request];
    
    if (resume) {
        [request resume];
    }
    
    [self checkStateChange];
}

- (void)resume
{
    for (SRGRequest *request in self.requests) {
        [request resume];
    }
}

- (void)cancel
{
    for (SRGRequest *request in self.requests) {
        [request cancel];
    }
}

- (void)reportError:(NSError *)error
{
    if (!error) {
        return;
    }
    [self.errors addObject:error];
}

- (NSError *)consolidatedError
{
    if (self.errors.count <= 1) {
        return self.errors.firstObject;
    }
    else {
        return [NSError errorWithDomain:SRGDataProviderErrorDomain
                                   code:SRGDataProviderErrorMultiple
                               userInfo:@{ SRGDataProviderErrorsKey : self.errors }];
    }
}

- (BOOL)isFinished
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"running == YES"];
    return [self.requests filteredArrayUsingPredicate:predicate].count == 0;
}

- (void)checkStateChange
{
    if (_wasFinished != self.finished) {
        NSError *error = [self consolidatedError];
        self.stateChangeBlock ? self.stateChangeBlock(self.finished, error) : nil;
        
        // Reset error list when finished
        [self.errors removeAllObjects];
        _wasFinished = self.finished;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == s_kvoContext && [keyPath isEqualToString:@"running"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkStateChange];
        });
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; requests: %@; finished: %@>",
            [self class],
            self,
            self.requests,
            self.finished ? @"YES" : @"NO"];
}

@end
