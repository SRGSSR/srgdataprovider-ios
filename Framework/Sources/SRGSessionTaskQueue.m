//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSessionTaskQueue.h"

#import "SRGDataProviderError.h"

static void *s_kvoContext = &s_kvoContext;

@interface SRGSessionTaskQueue () {
@private
    BOOL _wasFinished;
}

@property (nonatomic) NSMutableArray<NSURLSessionTask *> *sessionTasks;
@property (nonatomic, copy) void (^stateChangeBlock)(BOOL running, NSError *error);
@property (nonatomic) NSMutableArray<NSError *> *errors;

@end

@implementation SRGSessionTaskQueue

- (instancetype)initWithStateChangeBlock:(void (^)(BOOL, NSError *))stateChangeBlock
{
    if (self = [super init]) {
        self.sessionTasks = [NSMutableArray array];
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
    for (NSURLSessionTask *sessionTask in self.sessionTasks) {
        [sessionTask removeObserver:self forKeyPath:@"state" context:s_kvoContext];
    }
    [self checkStateChange];
}

- (void)addSessionTask:(NSURLSessionTask *)sessionTask resume:(BOOL)resume
{
    if (resume) {
        [sessionTask resume];
    }
    
    [sessionTask addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:s_kvoContext];
    [self.sessionTasks addObject:sessionTask];
    [self checkStateChange];
}

- (void)resume
{
    for (NSURLSessionTask *sessionTask in self.sessionTasks) {
        [sessionTask resume];
    }
}

- (void)cancel
{
    for (NSURLSessionTask *sessionTask in self.sessionTasks) {
        [sessionTask cancel];
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
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSURLSessionTask * _Nonnull sessionTask, NSDictionary<NSString *,id> * _Nullable bindings) {
        return sessionTask.state == NSURLSessionTaskStateCompleted;
    }];
    return [self.sessionTasks filteredArrayUsingPredicate:predicate].count == self.sessionTasks.count;
}

- (void)checkStateChange
{
    if (_wasFinished != self.finished) {
        NSError *error = [self consolidatedError];
        self.stateChangeBlock ? self.stateChangeBlock(self.finished, error) : nil;
        _wasFinished = self.finished;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == s_kvoContext && [keyPath isEqualToString:@"state"]) {
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
    return [NSString stringWithFormat:@"<%@: %p; sessionTasks: %@; finished: %@>",
            [self class],
            self,
            self.sessionTasks,
            self.finished ? @"YES" : @"NO"];
}

@end
