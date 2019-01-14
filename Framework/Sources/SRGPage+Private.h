//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface used for implementation purposes. A page is created on the basis of an initial request,
 *  stored within it, and used for generating subsequent pages (either by tweaking it locally, or by overriding
 *  it with a new URL retrieved from a service with pagination support).
 */
@interface SRGPage (Private)

/**
 *  Return the `SRGPage` for the first page of content associated with a request, with the specified page size.
 *
 *  @param originalURLRequest The request to create the first page for.
 *  @param size               The page size to use. Values < 1 will be fixed to 1, and values too large will be fixed
 *                            to the maximum page size.
 */
+ (SRGPage *)firstPageForOriginalURLRequest:(NSURLRequest *)originalURLRequest withSize:(NSUInteger)size;

/**
 *  Build the page immediately following the receiver, associating it the path where more content can be retrieved.
 *  If no next page exists, the method returns `nil`.
 *
 *  @param URL The URL were a next page of result can be retrieved, if any has been provided by the service. If not
 *             specified, the next URL is derviced from the original request, if possible.
 */
- (nullable SRGPage *)nextPageWithURL:(nullable NSURL *)URL;

/**
 *  Return the first page related to the receiver, with the specified page size.
 */
- (SRGPage *)firstPageWithSize:(NSUInteger)size;

/**
 *  Return the first page related to the receiver, with the same page size.
 */
@property (nonatomic, readonly) SRGPage *firstPage;

/**
 *  The request which must be executed to retrieve the page results.
 */
@property (nonatomic, readonly) NSURLRequest *URLRequest;

@end

NS_ASSUME_NONNULL_END
