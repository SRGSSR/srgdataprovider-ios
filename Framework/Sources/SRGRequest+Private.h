//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Block signatures.
typedef void (^SRGRequestCompletionBlock)(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error);

/**
 *  Private interface for implementation purposes.
 */
@interface SRGRequest (Private)

/**
 *  Create a request from a URL request, starting it with the provided session, and calling the specified block on completion.
 *
 *  @discussion The completion block is called on the main thread.
 */
- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock;

/**
 *  The underlying low-level request.
 */
@property (nonatomic, readonly) NSURLRequest *URLRequest;

/**
 *  The session.
 */
@property (nonatomic, readonly) NSURLSession *session;

@end

NS_ASSUME_NONNULL_END
