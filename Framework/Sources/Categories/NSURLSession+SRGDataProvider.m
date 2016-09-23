//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURLSession+SRGDataProvider.h"

#import "SRGRequest+Private.h"

static NSString * const SRGDataProviderErrorScheme = @"srgilerror";

/**
 * Special protocol registered on the fly, simply to use standard NSURLSessionTask logic to propagate errors. This makes
 * it easy to treat normal requests and early errors (e.g. parameter errors) with a single consistent formalism 
 * (NSURLSessionTask and completion handler). This way client code does not have to treat such early error detection
 * differently, e.g. when managing the user interface
 */
@interface SRGDataProviderErrorURLProtocol : NSURLProtocol

@end

@implementation SRGDataProviderErrorURLProtocol

#pragma mark Protocol implementation

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [request.URL.scheme isEqualToString:SRGDataProviderErrorScheme];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSError *dummyError = [[NSError alloc] initWithDomain:@"dummy" code:0 userInfo:nil];
    [self.client URLProtocol:self didFailWithError:dummyError /* Irrelevant. The real error be forwared afterwards in the completion handler */];
}

- (void)stopLoading
{}

@end

// Required identity hack, direct categories on NSURLSession are not possible.
// See http://stackoverflow.com/a/24428137/760435
@implementation NSObject /*NSURLSession*/ (SRGDataProvider)

- (SRGRequest *)srg_requestWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
{
    NSURLSession *realSelf = (NSURLSession *)self;
    
    __block SRGRequest *srgRequest = nil;
    NSURLSessionTask *sessionTask = [realSelf dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(data, response, error);
        srgRequest.running = NO;
    }];
    srgRequest = [[SRGRequest alloc] initWithSessionTask:sessionTask];
    return srgRequest;
}

- (SRGRequest *)srg_requestForError:(NSError *)error withCompletionHandler:(void (^)(NSError *))completionHandler
{
    // Register the error protocol on the fly
    NSURLSession *realSelf = (NSURLSession *)self;
    if (![realSelf.configuration.protocolClasses containsObject:[SRGDataProviderErrorURLProtocol class]]) {
        realSelf.configuration.protocolClasses = [realSelf.configuration.protocolClasses arrayByAddingObject:[SRGDataProviderErrorURLProtocol class]];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@://error", SRGDataProviderErrorScheme];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    return [realSelf srg_requestWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable dummyError) {
        completionHandler(error);
    }];
}

@end
