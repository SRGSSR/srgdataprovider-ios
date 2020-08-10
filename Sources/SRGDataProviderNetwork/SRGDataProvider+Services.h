//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGNetwork;

NS_ASSUME_NONNULL_BEGIN

// Completion block signatures (without pagination support).
typedef void (^SRGChannelCompletionBlock)(SRGChannel * _Nullable channel, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGChannelListCompletionBlock)(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGMediaCompletionBlock)(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGModuleListCompletionBlock)(NSArray<SRGModule *> * _Nullable modules, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGServiceMessageCompletionBlock)(SRGServiceMessage * _Nullable serviceMessage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGShowCompletionBlock)(SRGShow * _Nullable show, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGShowStatisticsOverviewCompletionBlock)(SRGShowStatisticsOverview * _Nullable showStatisticsOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGSocialCountOverviewCompletionBlock)(SRGSocialCountOverview * _Nullable socialCountOverview, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGSongCompletionBlock)(SRGSong * _Nullable song, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);

// Completion block signatures (with pagination support). For requests supporting it, the total number of results is returned.
typedef void (^SRGPaginatedEpisodeCompositionCompletionBlock)(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGPaginatedMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGPaginatedMediaSearchCompletionBlock)(NSArray<NSString *> * _Nullable mediaURNs, NSNumber *total, SRGMediaAggregations * _Nullable aggregations, NSArray<SRGSearchSuggestion *> * _Nullable suggestions, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGPaginatedProgramCompositionCompletionBlock)(SRGProgramComposition * _Nullable programComposition, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGPaginatedShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGPaginatedShowSearchCompletionBlock)(NSArray<NSString *> * _Nullable showURNs, NSNumber *total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);
typedef void (^SRGPaginatedSongListCompletionBlock)(NSArray<SRGSong *> * _Nullable songs, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error);

/**
 *  List of TV-oriented services supported by the data provider. Media list requests collect content for all channels
 *  and do not make any distinction between them.
 */
@interface SRGDataProvider (TVServices)

/**
 *  @name Channels and livestreams
 */

/**
 *  List of TV channels.
 */
- (SRGRequest *)tvChannelsForVendor:(SRGVendor)vendor
                withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific TV channel. Use this request to obtain complete channel information, including current and next programs.
 *
 *  Please https://github.com/SRGSSR/srgdataprovider-ios/wiki/Channel-information for more information about this method.
 */
- (SRGRequest *)tvChannelForVendor:(SRGVendor)vendor
                           withUid:(NSString *)channelUid
                   completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  Latest programs for a specific TV channel, including current and next programs. An optional date range (possibly
 *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
 *  provided, only programs up to the current date are returned.
 *
 *  @param livestreamUid An optional media unique identifier (usually regional, but might be the main one). If provided,
 *                       the program of the specified livestream is used, otherwise the one of the main channel.
 *
 *  @discussion Though the completion block does not return an array directly, this request supports pagination (for programs
 *              returned in the program composition object).
 */
- (SRGFirstPageRequest *)tvLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(nullable NSString *)livestreamUid
                                          fromDate:(nullable NSDate *)fromDate
                                            toDate:(nullable NSDate *)toDate
                               withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock;

/**
 *  List of TV livestreams.
 */
- (SRGRequest *)tvLivestreamsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List of TV scheduled livestreams.
 */
- (SRGFirstPageRequest *)tvScheduledLivestreamsForVendor:(SRGVendor)vendor
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Medias which have been picked by editors.
 */
- (SRGFirstPageRequest *)tvEditorialMediasForVendor:(SRGVendor)vendor
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest medias.
 */
- (SRGFirstPageRequest *)tvLatestMediasForVendor:(SRGVendor)vendor
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular medias.
 */
- (SRGFirstPageRequest *)tvMostPopularMediasForVendor:(SRGVendor)vendor
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Medias which will soon expire.
 */
- (SRGFirstPageRequest *)tvSoonExpiringMediasForVendor:(SRGVendor)vendor
                                   withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias (with all editorial recommendations).
 *
 *  @param limit The maximum number of results returned (if `nil`, 10 results at most will be returned).
 */
- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor
                                withLimit:(nullable NSNumber *)limit
                          completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias. A limit can be set on editorial recommendations and results can be restricted to episodes only
 *  (eliminating clips, teasers, etc.).
 *
 *  @param limit          The maximum number of results returned (if `nil`, 10 results at most will be returned).
 *                        The maximum limit is 50.
 *  @param editorialLimit The maximum number of editorial recommendations returned (if `nil`, all are returned).
 *  @param episodesOnly   Whether only episodes must be returned.
 */
- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor
                                withLimit:(nullable NSNumber *)limit
                           editorialLimit:(nullable NSNumber *)editorialLimit
                             episodesOnly:(BOOL)episodesOnly
                          completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes.
 */
- (SRGFirstPageRequest *)tvLatestEpisodesForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for a given day.
 *
 *  @param day The day. If `nil`, today is used.
 */
- (SRGFirstPageRequest *)tvEpisodesForVendor:(SRGVendor)vendor
                                         day:(nullable SRGDay *)day
                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Topics
 */

/**
 *  Topics.
 */
- (SRGRequest *)tvTopicsForVendor:(SRGVendor)vendor
              withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows.
 */
- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                      withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get complete show objects,
 *              call the `-showsWithURNs:completionBlock:` request with the returned URN list.
 */
- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query
                      withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock;

@end

/**
 *  List of TV-oriented services supported by the data provider. Radio channels have separate identities and programs,
 *  this is why retrieving media lists requires the unique identifier of a channel to be specified.
 */
@interface SRGDataProvider (RadioServices)

/**
 *  @name Channels and livestreams
 */

/**
 *  List of radio channels.
 */
- (SRGRequest *)radioChannelsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific radio channel. Use this request to obtain complete channel information, including current and next programs.
 *
 *  Please https://github.com/SRGSSR/srgdataprovider-ios/wiki/Channel-information for more information about this method.
 *
 *  @param livestreamUid An optional media unique identifier (usually regional, but might be the main one). If provided,
 *                       the program of the specified live stream is used, otherwise the one of the main channel.
 */
- (SRGRequest *)radioChannelForVendor:(SRGVendor)vendor
                              withUid:(NSString *)channelUid
                        livestreamUid:(nullable NSString *)livestreamUid
                      completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  Latest programs for a specific radio channel, including current and next programs. An optional date range (possibly
 *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
 *  provided, only programs up to the current date are returned.
 *
 *  @param livestreamUid An optional media unique identifier (usually the main one). If provided,
 *                       the program of the specified livestream is used, otherwise the one of the main channel.
 *
 *  @discussion Though the completion block does not return an array directly, this request supports pagination (for programs
 *              returned in the program composition object).
 */
- (SRGFirstPageRequest *)radioLatestProgramsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                        livestreamUid:(nullable NSString *)livestreamUid
                                             fromDate:(nullable NSDate *)fromDate
                                               toDate:(nullable NSDate *)toDate
                                  withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock;

/**
 *  List of radio livestreams for a channel.
 *
 *  @param channelUid The channel uid for which audio livestreams (main and regional) must be retrieved.
 */
- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List of radio livestreams.
 *
 *  @param contentProviders The content providers to return radio livestreams for.
 */
- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                         contentProviders:(SRGContentProviders)contentProviders
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Latest medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for a given day, for the specific channel.
 *
 *  @param day The day. If `nil`, today is used.
 */
- (SRGFirstPageRequest *)radioEpisodesForVendor:(SRGVendor)vendor
                                            day:(nullable SRGDay *)day
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest video medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Topics
 */

/**
 *  Topics.
 */
- (SRGRequest *)radioTopicsForVendor:(SRGVendor)vendor
                 withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows by channel.
 */
- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get complete show objects,
 *              call the `-showsWithURNs:completionBlock:` request with the returned URN list.
 */
- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
                         withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock;

/**
 *  @name Song list
 */

/**
 *  Song list by channel.
 */
- (SRGFirstPageRequest *)radioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock;

/**
 *  Current song by channel.
 *
 *  @discussion If no song is currently being played, the completion block is called with both song and error set to `nil`.
 */
- (SRGRequest *)radioCurrentSongForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGSongCompletionBlock)completionBlock;

@end

/**
 *  List of services offered by the SwissTXT Live Center.
 */
@interface SRGDataProvider (LiveCenterServices)

/**
 *  List of videos available from the Live Center.
 */
- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

/**
 *  List of media search-oriented services supported by the data provider.
 */
@interface SRGDataProvider (SearchServices)

/**
 *  Search medias matching a specific query.
 *
 *  @discussion To get complete media objects, call the `-mediasWithURNs:completionBlock:` request with the returned
 *              URN list. Refer to the Service availability matrix for information about which vendors support settings.
 *              By default aggregations are returned, which can lead to longer response times. If you do not need
 *              aggregations, provide a settings object to disable them.
 */
- (SRGFirstPageRequest *)mediasForVendor:(SRGVendor)vendor
                           matchingQuery:(nullable NSString *)query
                            withSettings:(nullable SRGMediaSearchSettings *)settings
                         completionBlock:(SRGPaginatedMediaSearchCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @param mediaType If set to a value different from `SRGMediaTypeNone`, filter shows for which content of the specified
 *                   type is available. To get complete show objects, call the `-showsWithURNs:completionBlock:` request
 *                   with the returned URN list.
 */
- (SRGFirstPageRequest *)showsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType
                    withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock;
/**
 *  Retrieve the list of shows which are searched the most.
 */
- (SRGRequest *)mostSearchedShowsForVendor:(SRGVendor)vendor
                       withCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

/**
 *  List medias with specific tags.
 *
 *  @param tags               List of tags (at least one is required).
 *  @param excludedTags       An optional list of excluded tags.
 *  @param fullLengthExcluded Set to `YES` to exclude full length videos.
 */
- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(nullable NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
                         completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

/**
 *  List of media recommendation services supported by the data provider.
 */
@interface SRGDataProvider (RecommendationServices)

/**
 *  List recommended medias for a specific media URN and, optionally, a user id.
 *
 *  @param URN    A specific media URN.
 *  @param userId An optional user uid.
 */
- (SRGFirstPageRequest *)recommendedMediasForURN:(NSString *)URN
                                          userId:(nullable NSString *)userId
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

/**
 *  List of module services (e.g. events) supported by the data provider.
 */
@interface SRGDataProvider (ModuleServices)

/**
 *  List modules for a specific type (e.g. events).
 *
 *  @param moduleType A specific module type.
 */
- (SRGRequest *)modulesForVendor:(SRGVendor)vendor
                            type:(SRGModuleType)moduleType
             withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock;

@end

/**
 *  General services supported by the data provider.
 */
@interface SRGDataProvider (GeneralServices)

/**
 *  Retrieve a message from the service about its status, if there is currently one. If none is available, the
 *  call ends with an HTTP error.
 */
- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor
                    withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock;

@end

/**
 *  List of services for popularity measurements supported by the data provider.
 */
@interface SRGDataProvider (PopularityServices)

/**
 *  Increase the specified social count from 1 unit for the specified URN, with the corresponding event data
 *  (@see `SRGSubdivision` class).
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
- (SRGRequest *)mediaWithURN:(NSString *)mediaURN completionBlock:(SRGMediaCompletionBlock)completionBlock;

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
- (SRGRequest *)showWithURN:(NSString *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock;

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
