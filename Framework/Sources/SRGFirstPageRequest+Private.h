//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGFirstPageRequest.h"
#import "SRGPageRequest+Private.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for implementation purposes
 */
@interface SRGFirstPageRequest (Private)

/**
 *  Create a request from a URL request, starting it with the provided session, and calling the specified block on completion
 *
 *  @param page The page for which the request must be made. If `nil`, the first page will be requested.
 *
 *  @discussion The completion block is called on the main thread
 */
- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session pageCompletionBlock:(SRGPageCompletionBlock)pageCompletionBlock;

/**
 *  The maximum page size (defaults to `SRGPageMaximumSize`)
 */
@property (nonatomic) NSInteger maximumPageSize;

@end

NS_ASSUME_NONNULL_END
