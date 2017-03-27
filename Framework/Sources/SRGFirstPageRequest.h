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
 */
- (SRGFirstPageRequest *)requestWithPageSize:(NSInteger)pageSize;

/**
 *  Return an equivalent request, but for the specified page. You never instantiate pages yourself, you receive them
 *  from service requests supporting pagination
 *
 *  @param page The page to request. If nil, the first page is requested (for the same page size as the receiver)
 *
 *  @discussion The `-requestWithPage:` method must be called on a related request, otherwise the behavior is undefined.
 */
- (SRGPageRequest *)requestWithPage:(nullable SRGPage *)page;

@end

NS_ASSUME_NONNULL_END
