//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

#import "SRGPage+Private.h"
#import "SRGRequest+Private.h"

#import <UIKit/UIKit.h>

static NSInteger s_numberOfRunningRequests = 0;

@interface SRGRequest ()

@property (nonatomic) NSURLRequest *request;
@property (nonatomic, copy) SRGRequestCompletionHandler completionHandler;

@property (nonatomic) NSURLSessionTask *sessionTask;
@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation SRGRequest

#pragma mark Object lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionHandler:(SRGRequestCompletionHandler)completionHandler
{
    if (self = [super init]) {
        self.request = request;
        self.completionHandler = completionHandler;
        
        self.sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            self.completionHandler(data, response, error);
            self.running = NO;
        }];
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

#pragma mark Page management

- (SRGRequest *)requestWithPage:(SRGPage *)page session:(NSURLSession *)session
{
    NSURLRequest *request = [SRGPage request:self.request withPage:page];
    return [[[self class] alloc] initWithRequest:request session:session completionHandler:self.completionHandler];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; request: %@; running: %@>",
            [self class],
            self,
            self.request,
            self.running ? @"YES" : @"NO"];
}

@end
