//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

typedef void (^SRGILTokenRequestCompletionBlock) (NSURL *tokenizedURL, NSError *error);

@interface SRGILTokenHandler : NSObject

+ (instancetype)sharedHandler;

/**
 * Perform an async operation to return a tokenized URL
 */
- (NSURLSessionTask *)requestTokenForURL:(NSURL *)url
                         completionBlock:(SRGILTokenRequestCompletionBlock)completionBlock;

@end
