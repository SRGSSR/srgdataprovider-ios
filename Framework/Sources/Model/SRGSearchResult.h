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
 *  @discussion Unlike Integration Layer objects (which are partial versions of the real objects they are supposed to
 *              match), we just extract basic identifier information from search results. Another request must be made
 *              client-side to retrieve the full-fledged objects if needed. This eliminates the confusion between search
 *              objects which are similar but not almost equal to the objects the represent.
 */
@interface SRGSearchResult : SRGModel

/**
 *  The Uniform Resource Name identifying the object.
 */
@property (nonatomic, readonly, copy) NSString *URN;

@end

NS_ASSUME_NONNULL_END
