//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

#import <UIKit/UIKit.h>

static NSInteger s_numberOfRunningRequests = 0;

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
        self.managingNetworkActivityIndicator = YES;
    }
    return self;
}

#pragma mark Getters and setters

- (void)setManagingNetworkActivityIndicator:(BOOL)managingNetworkActivityIndicator
{
    if (self.running) {
        return;
    }
    
    _managingNetworkActivityIndicator = managingNetworkActivityIndicator;
}

- (void)setRunning:(BOOL)running
{
    if (running != _running && self.managingNetworkActivityIndicator) {
        if (running) {
            if (s_numberOfRunningRequests == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                });
            }
            ++s_numberOfRunningRequests;
        }
        else {
            --s_numberOfRunningRequests;
            if (s_numberOfRunningRequests == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
            }
        }
    }
    
    _running = running;
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
