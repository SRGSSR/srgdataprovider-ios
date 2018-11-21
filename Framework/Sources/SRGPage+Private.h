//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface used for implementation purposes.
 */
@interface SRGPage (Private)

/**
 *  Return the `SRGPage` for the first page of content, with the specified page size.
 *
 *  @param request The original request to create the first page for.
 *  @param size    The page size to use. Values < 1 will be fixed to 1, and values too large will be fixed to the maximum
 *                 page size.
 */
// TODO: Rename request -> URLRequest everywhere for pages
// TODO: pageSize / size consistency
+ (SRGPage *)firstPageForOriginalRequest:(NSURLRequest *)originalRequest withSize:(NSUInteger)size;

/**
 *  Build the page immediately following the receiver, associating it the path where more content can be retrieved.
 *  If no next page exists, the method returns `nil`.
 *
 *  @param URL The URL were a next page of result can be retrieved, if any. If not specified, it is derived
 *             from the page original URL.
 */
- (nullable SRGPage *)nextPageWithURL:(nullable NSURL *)URL;

/**
 *  Return the matching first page having the specified page size.
 */
- (SRGPage *)firstPageWithSize:(NSUInteger)size;

/**
 *  Return the first page, with the same page size.
 */
@property (nonatomic, readonly) SRGPage *firstPage;

/**
 *  The request to execute to retrieve the page.
 */
@property (nonatomic, readonly) NSURLRequest *request;

@end

NS_ASSUME_NONNULL_END
