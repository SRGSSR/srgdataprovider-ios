//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of services for popularity measurements supported by the data provider.
 */
@interface SRGDataProvider (PopularityServices)

/**
 *  Increase the specified social count of 1 unit for the specified URN, with the corresponding event data
 *  (see `SRGSubdivision` class).
 */
- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                                       URN:(NSString *)URN
                                     event:(NSString *)event
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock;

/**
 *  Increase the number of times a show has been viewed from search results.
 */
- (SRGRequest *)increaseSearchResultsViewCountForShow:(SRGShow *)show
                                  withCompletionBlock:(SRGShowStatisticsOverviewCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
