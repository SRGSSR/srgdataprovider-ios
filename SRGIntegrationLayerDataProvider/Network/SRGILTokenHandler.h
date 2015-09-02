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
- (void)requestTokenForURL:(NSURL *)url
 appendLogicalSegmentation:(NSString *)segmentation
           completionBlock:(SRGILTokenRequestCompletionBlock)completionBlock;

@end
