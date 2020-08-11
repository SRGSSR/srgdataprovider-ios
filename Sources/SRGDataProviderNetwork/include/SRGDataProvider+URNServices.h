//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of URN-based services supported by the data provider. Such services do not need explicit knowledge of what
 *  is requested (audio / video, for example) or of the business unit. They provide a way to retrieve content
 *  from any business unit. Some restrictions may apply, though, please refer to the documentation of each request
 *  for more information.
 */
@interface SRGDataProvider (URNServices)

/**
 *  Retrieve the media having the specified URN.
 *
 *  @discussion If you need to retrieve several medias, use `-mediasWithURNs:completionBlock:` instead.
 */
- (SRGRequest *)mediaWithURN:(NSString *)mediaURN
             completionBlock:(SRGMediaCompletionBlock)completionBlock;

/**
 *  Retrieve medias matching a URN list.
 *
 *  @discussion Partial results can be returned if some URNs are invalid. Note that you can mix audio and video URNs,
 *              or URNs from different business units.
 */
- (SRGFirstPageRequest *)mediasWithURNs:(NSArray<NSString *> *)mediaURNs
                        completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest medias for a specific topic.
 *
 *  @param topicURN The unique topic URN.
 */
- (SRGFirstPageRequest *)latestMediasForTopicWithURN:(NSString *)topicURN
                                     completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular videos for a specific topic.
 *
 *  @param topicURN The unique topic URN.
 */
- (SRGFirstPageRequest *)mostPopularMediasForTopicWithURN:(NSString *)topicURN
                                          completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Full media information needed to play a media.
 *
 *  @param standalone If set to `NO`, the returned media composition provides media playback information in context. If
 *                    set to `YES`, media playback is provided without context.
 */
- (SRGRequest *)mediaCompositionForURN:(NSString *)mediaURN
                            standalone:(BOOL)standalone
                   withCompletionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

/**
 *  Retrieve the show having the specified URN.
 */
- (SRGRequest *)showWithURN:(NSString *)showURN
            completionBlock:(SRGShowCompletionBlock)completionBlock;

/**
 *  Retrieve shows matching a URN list.
 *
 *  @discussion Partial results can be returned if some URNs are invalid. Note that you can mix TV or radio show URNs,
 *              or URNs from different business units.
 */
- (SRGFirstPageRequest *)showsWithURNs:(NSArray<NSString *> *)showURNs
                       completionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific show.
 *
 *  @param maximumPublicationDay If not `nil`, medias up to the specified day are returned.
 *
 *  @discussion Though the completion block does not return an array directly, this request supports pagination (for episodes
 *              returned in the episode composition object).
 */
- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(NSString *)showURN
                                maximumPublicationDay:(nullable SRGDay *)maximumPublicationDay
                                      completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock;

/**
 *  List medias for a specific module.
 */
- (SRGFirstPageRequest *)latestMediasForModuleWithURN:(NSString *)moduleURN
                                      completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
