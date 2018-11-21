//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGFirstPageRequest.h"
#import "SRGPageRequest+Private.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for implementation purposes.
 */
@interface SRGFirstPageRequest (Private)

/**
 *  Create a request from a URL request, associated with the provided session, and calling the specified block on completion.
 *
 *  @param URLRequest          The original request.
 *  @param session             The session to use.
 *  @param pageCompletionBlock The block to be called on completion.
 *
 *  @discussion The completion block is called on a background thread.
 */
- (instancetype)initWithURLRequest:(NSURLRequest *)URLRequest session:(NSURLSession *)session pageCompletionBlock:(SRGPageCompletionBlock)pageCompletionBlock;

@end

NS_ASSUME_NONNULL_END
