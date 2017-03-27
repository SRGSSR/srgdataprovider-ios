//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

#import "NSBundle+SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGDataProviderLogger.h"
#import "SRGRequest+Private.h"

#import <UIKit/UIKit.h>

static NSInteger s_numberOfRunningRequests = 0;

@interface SRGRequest ()

@property (nonatomic) NSURLRequest *request;
@property (nonatomic, copy) SRGRequestCompletionBlock completionBlock;

@property (nonatomic) NSURLSessionTask *sessionTask;
@property (nonatomic, weak) NSURLSession *session;

@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation SRGRequest

#pragma mark Object lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock
{
    if (self = [super init]) {
        self.request = request;
        self.completionBlock = completionBlock;
        self.session = session;
        self.managingNetworkActivityIndicator = YES;
    }
    return self;
}

- (void)dealloc
{
    [self.sessionTask cancel];
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
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
            ++s_numberOfRunningRequests;
        }
        else {
            --s_numberOfRunningRequests;
            if (s_numberOfRunningRequests == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }
    }
    
    _running = running;
}

#pragma mark Session task management

- (void)resume
{
    if (self.running) {
        return;
    }
    
    // No weakify / strongify dance here, so that the request retains itself while it is running
    void (^requestCompletionBlock)(BOOL finished, NSDictionary * _Nullable, NSError * _Nullable) = ^(BOOL finished, NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                self.completionBlock(JSONDictionary, error);
            }
            self.running = NO;
        });
    };
    
    SRGDataProviderLogDebug(@"Request", @"Started %@", self.request.URL);
    
    // Session tasks cannot be reused. To provide SRGRequest reuse, we need to instantiate another task
    self.sessionTask = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Don't call the completion block for cancelled requests
        if (error) {
            if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
                SRGDataProviderLogDebug(@"Request", @"Cancelled %@", self.request.URL);
                requestCompletionBlock(NO, nil, error);
            }
            else {
                SRGDataProviderLogDebug(@"Request", @"Ended %@ with an error: %@", self.request.URL, error);
                requestCompletionBlock(YES, nil, error);
            }
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            NSInteger HTTPStatusCode = HTTPURLResponse.statusCode;
            
            // Properly handle HTTP error codes >= 400 as real errors
            if (HTTPStatusCode >= 400) {
                NSError *HTTPError = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                         code:SRGDataProviderErrorHTTP
                                                     userInfo:@{ NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:HTTPStatusCode],
                                                                 NSURLErrorKey : response.URL,
                                                                 SRGDataProviderHTTPStatusCodeKey : @(HTTPStatusCode) }];
                SRGDataProviderLogDebug(@"Request", @"Ended %@ with an HTTP error: %@", self.request.URL, HTTPError);
                requestCompletionBlock(YES, nil, HTTPError);
                return;
            }
            // Block redirects and return an error with URL information. Currently no redirection is expected for IL services, this
            // means redirection is probably related to a public hotspot with login page (e.g. SBB)
            else if (HTTPStatusCode >= 300) {
                NSMutableDictionary *userInfo = [@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"You are likely connected to a public wifi network with no Internet access", nil),
                                                    NSURLErrorKey : response.URL } mutableCopy];
                
                NSString *redirectionURLString = HTTPURLResponse.allHeaderFields[@"Location"];
                if (redirectionURLString) {
                    NSURL *redirectionURL = [NSURL URLWithString:redirectionURLString];
                    userInfo[SRGDataProviderRedirectionURLKey] = redirectionURL;
                }
                
                NSError *redirectError = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                             code:SRGDataProviderErrorRedirect
                                                         userInfo:[userInfo copy]];
                SRGDataProviderLogDebug(@"Request", @"Ended %@ with a redirect error: %@", self.request.URL, redirectError);
                requestCompletionBlock(YES, nil, redirectError);
                return;
            }
        }
        
        id JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (!JSONDictionary || ![JSONDictionary isKindOfClass:[NSDictionary class]]) {
            NSError *dataFormatError = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                           code:SRGDataProviderErrorCodeInvalidData
                                                       userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }];
            SRGDataProviderLogDebug(@"Request", @"Ended %@ with a data format error: %@", self.request.URL, dataFormatError);
            requestCompletionBlock(YES, nil, dataFormatError);
            return;
        }
        
        SRGDataProviderLogDebug(@"Request", @"Ended %@ successfully with JSON %@", self.request.URL, JSONDictionary);
        requestCompletionBlock(YES, JSONDictionary, nil);
    }];
    
    self.running = YES;
    [self.sessionTask resume];
}

- (void)cancel
{
    self.running = NO;
    [self.sessionTask cancel];
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
