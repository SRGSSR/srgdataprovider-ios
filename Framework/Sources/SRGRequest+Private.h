//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Block signatures
typedef void (^SRGRequestCompletionBlock)(NSDictionary * _Nullable JSONDictionary, SRGPage * _Nullable nextPage, NSError * _Nullable error);

/**
 *  Private interface for implementation purposes
 */
@interface SRGRequest (Private)

/**
 *  Create a request from a URL request, starting it with the provided session, and calling the specified block on completion
 */
- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
