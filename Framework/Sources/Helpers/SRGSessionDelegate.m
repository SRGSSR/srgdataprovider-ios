//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSessionDelegate.h"

@implementation SRGSessionDelegate

#pragma mark NSURLSessionDelegate protocol

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    // Refuse the redirection and return the redirection response (with the proper HTTP status code)
    completionHandler(nil);
}

@end
