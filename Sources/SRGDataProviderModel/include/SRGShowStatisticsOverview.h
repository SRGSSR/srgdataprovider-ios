//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShowIdentifierMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Information returned as result of a request updating show statistics.
 */
@interface SRGShowStatisticsOverview : SRGModel <SRGShowIdentifierMetadata>

/**
 *  Number of times the show has been viewed from search results.
 */
@property (nonatomic, readonly) NSInteger searchResultsViewCount;

@end

NS_ASSUME_NONNULL_END
