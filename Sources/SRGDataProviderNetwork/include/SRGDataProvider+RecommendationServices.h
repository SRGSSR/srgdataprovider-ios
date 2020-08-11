//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of media recommendation services supported by the data provider.
 */
@interface SRGDataProvider (RecommendationServices)

/**
 *  List recommended medias for a specific media URN and, optionally, a user id.
 *
 *  @param URN    A specific media URN.
 *  @param userId An optional user identifier.
 */
- (SRGFirstPageRequest *)recommendedMediasForURN:(NSString *)URN
                                          userId:(nullable NSString *)userId
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
