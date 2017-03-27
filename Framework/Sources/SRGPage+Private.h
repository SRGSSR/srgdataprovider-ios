//
//  Copyright (c) SRG. All rights reserved.
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
 *  Start from a request and add the necessary information to access a particular page.
 *
 *  @param request The original request.
 *  @param page    The page.
 */
+ (NSURLRequest *)request:(NSURLRequest *)request withPage:(SRGPage *)page;

/**
 *  Return the `SRGPage` for the first page of content, with the default size supported by the service. This
 *  default size is Integration Layer specific and may vary depending on the service.
 */
+ (SRGPage *)firstPageWithDefaultSize;

/**
 *  Return the `SRGPage` for the first page of content, with the specified page size.
 *
 *  @param size            The page size to use. Values < 1 will be fixed to 1, and values too large will be fixed to the
 *                         maximum page size.
 *  @param maximumPageSize The maximum value for the page size.
 */
+ (SRGPage *)firstPageWithSize:(NSInteger)size maximumPageSize:(NSInteger)maximumPageSize;

/**
 *  Build the page immediately following the receiver, associating it the path where more content can be retrieved.
 *
 *  @param path The URL were the next page of result can be retrieved.
 */
- (SRGPage *)nextPageWithURL:(NSURL *)URL;

/**
 *  Return the first page matching the receiver.
 */
@property (nonatomic, readonly) SRGPage *firstPage;

@end

NS_ASSUME_NONNULL_END
