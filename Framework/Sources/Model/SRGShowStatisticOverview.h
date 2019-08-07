//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShowIdentifierMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Information returned as the result of a request increasing most clicked search show results.
 */
@interface SRGShowStatisticOverview : SRGModel <SRGShowIdentifierMetadata>

/**
 *  The updated most clicked search result information.
 */
@property (nonatomic, readonly) NSInteger searchResultClicked;

@end

NS_ASSUME_NONNULL_END
