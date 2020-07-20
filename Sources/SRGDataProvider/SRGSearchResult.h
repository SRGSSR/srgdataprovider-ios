//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Search result.
 *
 *  @discussion Unlike Integration Layer search result objects (which are partial representations of the real objects they
 *              are referring to), we just extract basic identifier information from search results. Search requests will
 *              therefore only return identifiers, forcing another request to be made to retrieve full-fledged objects.
 *              This ensures that medias are always complete, and that our library users do not deal with partial data.
 */
@interface SRGSearchResult : SRGModel

/**
 *  The Uniform Resource Name identifying the object.
 */
@property (nonatomic, readonly, copy) NSString *URN;

@end

NS_ASSUME_NONNULL_END
