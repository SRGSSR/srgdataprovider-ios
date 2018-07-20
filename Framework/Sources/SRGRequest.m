//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

#import "NSBundle+SRGDataProvider.h"
#import "NSHTTPURLResponse+SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGDataProviderLogger.h"
#import "SRGRequest+Private.h"

#import <SRGNetwork/SRGNetwork.h>
#import <UIKit/UIKit.h>

static NSInteger s_numberOfRunningRequests = 0;
static void (^s_networkActivityManagementHandler)(BOOL) = nil;

@interface SRGRequest ()

@property (nonatomic) SRGNetworkRequest *request;
@property (nonatomic) NSURLSession *session;

@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation SRGRequest

#pragma mark Object lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock
{
    if (self = [super init]) {
        // No weakify / strongify dance here, so that the request retains itself while it is running
        void (^requestCompletionBlock)(BOOL finished, NSDictionary * _Nullable, NSError * _Nullable) = ^(BOOL finished, NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
            if (finished) {
                completionBlock(JSONDictionary, error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.running = NO;
            });
        };
        
        self.session = session;
        self.request = [[SRGNetworkRequest alloc] initWithJSONDictionaryURLRequest:request session:session options:SRGNetworkRequestOptionCancellationErrorsProcessed completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
                    requestCompletionBlock(NO, nil, error);
                }
                else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorServerCertificateUntrusted) {
                    NSError *friendlyError = [NSError errorWithDomain:error.domain
                                                                 code:error.code
                                                             userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"You are likely connected to a public wifi network with no Internet access", @"The error message when request a media or a media list on a public network with no Internet access (e.g. SBB)"),
                                                                         NSURLErrorKey : request.URL }];
                    requestCompletionBlock(YES, nil, friendlyError);
                }
                else {
                    requestCompletionBlock(YES, nil, error);
                }
                return;
            }
            
            requestCompletionBlock(YES, JSONDictionary, nil);
        }];
    }
    return self;
}

- (void)dealloc
{
    [self.request cancel];
}

#pragma mark Getters and setters

- (void)setRunning:(BOOL)running
{
    if (running != _running) {
        if (running) {
            if (s_numberOfRunningRequests == 0) {
                s_networkActivityManagementHandler ? s_networkActivityManagementHandler(YES) : nil;
            }
            ++s_numberOfRunningRequests;
        }
        else {
            --s_numberOfRunningRequests;
            if (s_numberOfRunningRequests == 0) {
                s_networkActivityManagementHandler ? s_networkActivityManagementHandler(NO) : nil;
            }
        }
    }
    
    _running = running;
}

- (NSURLRequest *)URLRequest
{
    return self.request.URLRequest;
}

#pragma mark Session task management

- (void)resume
{
    if (self.running) {
        return;
    }
    
    self.running = YES;
    [self.request resume];
}

- (void)cancel
{
    self.running = NO;
    [self.request cancel];
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

@implementation SRGRequest (AutomaticNetworkActivityManagement)

#pragma mark Class methods

+ (void)enableNetworkActivityManagementWithHandler:(void (^)(BOOL))handler
{
    s_networkActivityManagementHandler = handler;
    handler(s_numberOfRunningRequests != 0);
}

+ (void)enableNetworkActivityIndicatorManagement
{
    [self enableNetworkActivityManagementWithHandler:^(BOOL active) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = active;
    }];
}

+ (void)disableNetworkActivityManagement
{
    s_networkActivityManagementHandler ? s_networkActivityManagementHandler(NO) : nil;
    s_networkActivityManagementHandler = nil;
}

@end
