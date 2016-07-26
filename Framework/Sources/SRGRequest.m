//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

@interface SRGRequest ()

@property (nonatomic) NSURLSessionTask *sessionTask;
@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation SRGRequest

#pragma mark Object lifecycle

- (instancetype)initWithSessionTask:(NSURLSessionTask *)sessionTask
{
    if (self = [super init]) {
        self.sessionTask = sessionTask;
    }
    return self;
}

#pragma mark Session task management

- (void)resume
{
    self.running = YES;
    [self.sessionTask resume];
}

- (void)cancel
{
    [self.sessionTask cancel];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; sessionTask: %@; running: %@>",
            [self class],
            self,
            self.sessionTask,
            self.running ? @"YES" : @"NO"];
}

@end
