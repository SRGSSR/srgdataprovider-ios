//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequestQueue.h"

#import "NSBundle+SRGDataProvider.h"
#import "SRGDataProviderError.h"

static void *s_kvoContext = &s_kvoContext;

@interface SRGRequestQueue () {
@private
    BOOL _wasRunnning;
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
                               userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"Several errors have been encountered", nil),
                                           SRGDataProviderErrorsKey : self.errors }];
    }
}

- (BOOL)isRunning
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"running == YES"];
    return [self.requests filteredArrayUsingPredicate:predicate].count != 0;
}

- (void)checkStateChange
{
    if (_wasRunnning != self.running) {
        if (self.running) {
            [self.errors removeAllObjects];
            self.stateChangeBlock ? self.stateChangeBlock(NO, nil) : nil;
        }
        else {
            NSError *error = [self consolidatedError];
            self.stateChangeBlock ? self.stateChangeBlock(YES, error) : nil;
        }
        _wasRunnning = self.running;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == s_kvoContext && [keyPath isEqualToString:@"running"]) {
        [self checkStateChange];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; requests: %@; running: %@>",
            [self class],
            self,
            self.requests,
            self.running ? @"YES" : @"NO"];
}

@end
