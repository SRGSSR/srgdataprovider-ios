//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPageRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Request for the first page of results.
 */
@interface SRGFirstPageRequest : SRGPageRequest

/**
 *  Return an equivalent request, but with the specified page size
 *
 *  @param pageSize The page size to use (values below 1 will be set to 1)
 *
 *  @discussion If `requestWithPageSize:`called twice or more, only the latest called value will be considered.
 *              `-requestWithPageSize:` can only on be called on the request for the first page.
 */
- (SRGFirstPageRequest *)requestWithPageSize:(NSInteger)pageSize;

/**
 *  Return an equivalent request, but for the specified page. You never instantiate pages yourself, you receive them
 *  from service requests supporting pagination
 *
 *  @param page The page to request. If nil, the first page is requested (for the same page size as the receiver)
 *
 *  @discussion The `-requestWithPage:` method must be called on a related request, otherwise the behavior is undefined.
 *              When using a next page, You must NOT complete the request with the `requestWithPageSize:`method. PageSize is
 *              already known by the IL service, and it's the same as the page size in your first request.
 */
- (SRGPageRequest *)requestWithPage:(nullable SRGPage *)page;

@end

NS_ASSUME_NONNULL_END
