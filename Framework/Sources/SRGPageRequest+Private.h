//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPageRequest.h"

NS_ASSUME_NONNULL_BEGIN

// Block signatures
typedef void (^SRGPageRequestCompletionBlock)(NSDictionary * _Nullable JSONDictionary, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);

/**
 *  Private interface for implementation purposes
 */
@interface SRGPageRequest (Private)

/**
 *  Create a request from a URL request, starting it with the provided session, and calling the specified block on completion
 *
 *  @param page The page for which the request must be made. If `nil`, the first page will be requested.
 *
 *  @discussion The completion block is called on the main thread
 */
- (instancetype)initWithRequest:(NSURLRequest *)request page:(nullable SRGPage *)page session:(NSURLSession *)session completionBlock:(SRGPageRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
