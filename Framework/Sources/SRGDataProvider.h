//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

// Public framework imports
#import "SRGChannel.h"
#import "SRGChapter.h"
#import "SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGEpisode.h"
#import "SRGEpisodeComposition.h"
#import "SRGFirstPageRequest.h"
#import "SRGImageMetadata.h"
#import "SRGMedia.h"
#import "SRGMediaComposition.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGMediaMetadata.h"
#import "SRGMediaParentMetadata.h"
#import "SRGMediaURN.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGModule.h"
#import "SRGPage.h"
#import "SRGPageRequest.h"
#import "SRGPresenter.h"
#import "SRGProgram.h"
#import "SRGRelatedContent.h"
#import "SRGRequest.h"
#import "SRGRequestQueue.h"
#import "SRGResource.h"
#import "SRGSearchResult.h"
#import "SRGSearchResultMedia.h"
#import "SRGSearchResultShow.h"
#import "SRGSection.h"
#import "SRGSegment.h"
#import "SRGShow.h"
#import "SRGSocialCount.h"
#import "SRGSubtitle.h"
#import "SRGTopic.h"
#import "SRGTypes.h"
#import "SRGMediaURN.h"

NS_ASSUME_NONNULL_BEGIN

// Official version number.
OBJC_EXPORT NSString *SRGDataProviderMarketingVersion(void);

// Official service URLs.
OBJC_EXPORT NSURL *SRGIntegrationLayerProductionServiceURL(void);
OBJC_EXPORT NSURL *SRGIntegrationLayerStagingServiceURL(void);
OBJC_EXPORT NSURL *SRGIntegrationLayerTestServiceURL(void);

// Official business identifiers.
typedef NSString * SRGDataProviderBusinessUnitIdentifier NS_STRING_ENUM;

OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRSI;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTR;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTS;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSRF;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSWI;

// Completion block signatures (without pagination support).
typedef void (^SRGChannelCompletionBlock)(SRGChannel * _Nullable channel, NSError * _Nullable error);
typedef void (^SRGChannelListCompletionBlock)(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error);
typedef void (^SRGMediaCompletionBlock)(SRGMedia * _Nullable media, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error);
typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error);
typedef void (^SRGModuleListCompletionBlock)(NSArray<SRGModule *> * _Nullable modules, NSError * _Nullable error);
typedef void (^SRGShowCompletionBlock)(SRGShow * _Nullable show, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error);
typedef void (^SRGURLCompletionBlock)(NSURL * _Nullable URL, NSError * _Nullable error);

// Completion block signatures (with pagination support).
typedef void (^SRGPaginatedEpisodeCompositionCompletionBlock)(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedSearchResultMediaListCompletionBlock)(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedSearchResultShowListCompletionBlock)(NSArray<SRGSearchResultShow *> * _Nullable searchResults, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);

/**
 *  A data provider supplies metadata for an SRG SSR business unit (media and show lists, mostly). Several data providers
 *  can coexist in an application, though most applications should only require one.
 *
 *  The data provider requests data from the Integration Layer, the SRG SSR service responsible of delivering metadata
 *  common to all SRG SSR business units. To avoid unnecessary requests, the data provider relies on the standard
 *  built-in iOS URL cache (`NSURLCache`).
 *
 *  ## Instantiation
 *
 *  You instantiate a data provider with a service base URL and a business unit identifier. The service URL must expose
 *  services whose endpoints start with 'integrationlayer/', corresponding to a working Integration Layer installation.
 *
 *  If your application only requires data from a single business unit, you can use the data provider you need like a singleton
 *  by instantiating it early in your application lifecycle (e.g. in your `-applicationDidFinishLaunching:withOptions:`
 *  implementation) and setting it as global shared instance by calling `-[SRGDataProvider setCurrentDataProvider:]`.
 *  You can then conveniently retrieve this shared instance with `-[SRGDataProvider currentDataProvider]`.
 *
 *  ## Lifetime
 *
 *  A data provider must be retained somewhere, at least when executing a request retrieved from it (otherwise the request
 *  will be automatically cancelled when the data provider is deallocated). You can e.g. use the global instance or store the
 *  data provider you use locally.
 *
 *  ## Thread-safety
 *
 *  The data provider library does not make any guarantees regarding thread safety. Though highly asynchronous in nature
 *  during data retrieval and parsing, the library public interface is meant to be used from the main thread only. Data
 *  provider creation and requests must be performed from the main thread. Accordingly, completion blocks are guaranteed
 *  to be called on the main thread as well.
 *
 *  This choice was made to prevent programming errors, since requests will usually be triggered by user interactions,
 *  and result in the UI being updated. Trying to use this library from any other thread except the main one will result
 *  in undefined behavior (i.e. it may work or not, and may or not break in the future).
 *
 *  ## Requesting data
 *
 *  To request data, use the methods from the various 'Services' category. These methods return an `SRGRequest` object,
 *  which lets you manage the request process itself (starting or cancelling data retrieval), and are basically
 *  separated in three major groups:
 *    - TV-related services, whose methods start with `tv`.
 *    - Radio related services (which commonly require a channel identifier to be specified), whose methods start with
 *      `radio`.
 *    - Other services.
 *
 *  Requests must be started when needed by calling the `-resume` method, and expect a mandatory completion block,
 *  called when the request finishes (either normally or with an error).
 *
 *  You can keep a reference to an `SRGRequest` you have started. This can be useful if you later need to cancel the
 *  request, or to start it again. Note that the completion block will not be called when a request is cancelled.
 *
 *  ## Service availability
 *
 *  Service availability depends on the business unit. Have a look at the `Documentation/Service-availability.md` file
 *  supplied with this project documentation for more information.
 *
 *  ## Page management
 *
 *  Some services support pagination (retrieving results in pages with a bound number of results for each). Such requests
 *  must always start with the first page of content and proceed by successively retrieving further pages, as follows:
 *
 *  1. Get the `SRGRequest` for a service supporting pagination by calling the associated method from a 'Services'
 *     category. Services supporting pagination are easily recognized by looking at their completion block signature,
 *     which contains a `nextPage` parameter.
 *  1. Once the request completes, you obtain a `nextPage` parameter from the completion block. If this parameter is
 *     not `nil`, you can use it to generate the request for the next page of content, by calling `[request requestWithPage:nextPage]`
 *     on your previous request, and starting it when needed.
 *  1. You can continue requesting further pages until `nil` is returned as `nextPage`, at which point you have
 *     retrieved all available pages of results.
 *
 *  Most applications will not directly request the next page of content from the completion block, though. In general,
 *  the `nextPage` could be stored by your application, so that it is readily available when the next request needs
 *  to be generated (e.g. when scrolling reaches the bottom of a result table). You can also directly generate the
 *  next request and store it instead.
 *
 *  Note that you cannot generate arbitrary pages (e.g. you can ask to get the 4th page of content with a page size of
 *  20 items), as this use case is not supported by Integration Layer services. If you need to reload the whole result
 *  set, start again with the first request. If results have not changed in the meantime, though, pages will load in a
 *  snap thanks to the URL caching mechanism.
 *
 *  ## Request queues
 *
 *  Managing parallel or cascading requests is usually tricky to get right. To make this process as easy as possible,
 *  the data provider library provides a request queue class (`SRGRequestQueue`). Queues group requests and call a
 *  completion block to notify when some of their requests start, or when all requests have ended. Queues let you
 *  manage parallel or cascading requests with a unified formalism, and provide a way to report errors along the way.
 *  For more information, @see `SRGRequestQueue`.
 */
@interface SRGDataProvider : NSObject

/**
 *  The data provider currently set as shared instance, if any.
 *
 *  @see `-setCurrentDataProvider:`.
 */
+ (nullable SRGDataProvider *)currentDataProvider;

/**
 *  Set a data provider as shared instance for convenient retrieval via `-currentDataProvider`.
 *
 *  @return The previously installed shared instance, if any.
 */
+ (nullable SRGDataProvider *)setCurrentDataProvider:(nullable SRGDataProvider *)currentDataProvider;

/**
 *  Instantiate a data provider.
 *
 *  @param serviceURL             The Integration Layer service base URL (which must expose service endpoints
 *                                starting with '/integrationlayer'). Official service URLs are available at
 *                                the top of this header file.
 *
 *  @param businessUnitIdentifier The identifier of the SRG SSR business unit to retrieve data for. Use constants
 *                                available at the top of this file for the officially supported values.
 */
- (instancetype)initWithServiceURL:(NSURL *)serviceURL
            businessUnitIdentifier:(NSString *)businessUnitIdentifier NS_DESIGNATED_INITIALIZER;

/**
 *  The service URL which has been set.
 *
 *  @discussion Always ends with a slash, even if the service URL set at creaioon wasn't.
 */
@property (nonatomic, readonly) NSURL *serviceURL;

/**
 *  The business unit identifier which has been set.
 */
@property (nonatomic, readonly, copy) NSString *businessUnitIdentifier;

@end

/**
 *  List of TV-oriented services supported by the data provider. TV channels are not considered as separate, media list
 *  requests therefore return results stemming for all channels at the same time.
 */
@interface SRGDataProvider (TVServices)

/**
 *  @name Channels and livestreams
 */

/**
 *  Channels.
 */
- (SRGRequest *)tvChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific channel. Use this request to obtain complete channel information, including current and next programs).
 */
- (SRGRequest *)tvChannelWithUid:(NSString *)channelUid completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  Livestreams.
 */
- (SRGRequest *)tvLivestreamsWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Medias which have been picked by editors.
 */
- (SRGFirstPageRequest *)tvEditorialMediasWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Medias which will soon expire.
 */
- (SRGFirstPageRequest *)tvSoonExpiringMediasWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias (with all editorial recommendations).
 */
- (SRGFirstPageRequest *)tvTrendingMediasWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias. A limit can be set on editorial recommendations and results can be limited to episodes
 *  (eliminating clips, teasers, etc.).
 *
 *  @param editorialLimit The maximum number of editorial recommendations returned (if `nil`, all are returned).
 *  @param episodesOnly   Whether only episodes must be returned.
 */
- (SRGFirstPageRequest *)tvTrendingMediasWithEditorialLimit:(nullable NSNumber *)editorialLimit
                                               episodesOnly:(BOOL)episodesOnly
                                            completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes.
 */
- (SRGFirstPageRequest *)tvLatestEpisodesWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for the day containing the given date.
 *
 *  @param date The date. If `nil`, today is used.
 */
- (SRGFirstPageRequest *)tvEpisodesForDate:(nullable NSDate *)date
                       withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Retrieve the media having the specified uid.
 *
 *  @discussion If you need to retrieve several videos, use `-tvMediasWithUids:completionBlock:` instead.
 */
- (SRGRequest *)tvMediaWithUid:(NSString *)uid completionBlock:(SRGMediaCompletionBlock)completionBlock;

/**
 *  Retrieve medias matching a uid list.
 *
 *  @discussion The list must contain at least a uid, otherwise the results is undefined.
 */
- (SRGRequest *)tvMediasWithUids:(NSArray<NSString *> *)mediaUids
                 completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Topics
 */

/**
 *  Topics.
 */
- (SRGRequest *)tvTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  Latest medias for a specific topic.
 *
 *  @param topicUid The unique topic identifier. If none is specified, medias for any topic will be returned.
 */
- (SRGFirstPageRequest *)tvLatestMediasForTopicWithUid:(nullable NSString *)topicUid
                                       completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular videos for a specific topic.
 *
 *  @param topicUid The unique topic identifier. If none is specified, medias for any topic will be returned.
 */
- (SRGFirstPageRequest *)tvMostPopularMediasForTopicWithUid:(nullable NSString *)topicUid
                                            completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows.
 */
- (SRGFirstPageRequest *)tvShowsWithCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Retrieve the show having the specified uid.
 */
- (SRGRequest *)tvShowWithUid:(NSString *)showUid completionBlock:(SRGShowCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific show.
 *
 *  @param oldestMonth The oldest month for which medias are returned (if `nil`, all medias are returned).
 *
 *  @discussion Though the completion block does not return an array directly, this request supports paging (for episodes returned in the episode
 *              composition).
 */
- (SRGFirstPageRequest *)tvLatestEpisodesForShowWithUid:(NSString *)showUid
                                            oldestMonth:(nullable NSDate *)oldestMonth
                                        completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock;

/**
 *  @name Media composition
 */

/**
 *  Full media information needed to play a media.
 */
- (SRGRequest *)tvMediaCompositionWithUid:(NSString *)mediaUid
                          completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

/**
 *  @name Search
 */

/**
 *  Search medias matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get media objects, call the
 *              `-tvMediasWithUids:completionBlock:` request with the returned search results uid list.
 */
- (SRGFirstPageRequest *)tvMediasMatchingQuery:(NSString *)query
                           withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get media objects, call the
 *              `-videoShowsWithUids:completionBlock:` request with the returned search results uid list.
 */
- (SRGFirstPageRequest *)tvShowsMatchingQuery:(NSString *)query
                          withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock;

@end

/**
 *  List of TV-oriented services supported by the data provider. Radio channels have separate identities and programs,
 *  and as such retrieving media lists require the unique identifier of a channel to be specified.
 */
@interface SRGDataProvider (RadioServices)

/**
 *  @name Channels and livestreams
 */

/**
 *  Channels.
 */
- (SRGRequest *)radioChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific channel. Use this request to obtain complete channel information, including current and next programs).
 *
 *  @param livestreamUid An optional radio channel unique identifier (usually regional, but might be the main one). If provided,
 *                       the program of the specified live stream is used, otherwise the one of the main channel.
 */
- (SRGRequest *)radioChannelWithUid:(NSString *)channelUid
                      livestreamUid:(nullable NSString *)livestreamUid
                    completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  Livestreams.
 *
 *  @param channelUid The channel uid for which audio live streams (main and regional) must be retrieved. If not specified,
 *                    all main live streams are returned.
 */
- (SRGRequest *)radioLivestreamsForChannelWithUid:(nullable NSString *)channelUid
                                  completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Latest medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestMediasForChannelWithUid:(NSString *)channelUid
                                            completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioMostPopularMediasForChannelWithUid:(NSString *)channelUid
                                                 completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestEpisodesForChannelWithUid:(NSString *)channelUid
                                              completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodess available for the day containing the given date, for the specific channel.
 *
 *  @param date The date. If `nil`, today is used.
 */
- (SRGFirstPageRequest *)radioEpisodesForDate:(nullable NSDate *)date
                               withChannelUid:(NSString *)channelUid
                              completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Retrieve the media having the specified uid.
 *
 *  @discussion If you need to retrieve several videos, use `-radioMediasWithUids:completionBlock:` instead.
 */
- (SRGRequest *)radioMediaWithUid:(NSString *)uid completionBlock:(SRGMediaCompletionBlock)completionBlock;

/**
 *  Retrieve medias matching a uid list.
 *
 *  @discussion The list must contain at least a uid, otherwise the results is undefined.
 */
- (SRGRequest *)radioMediasWithUids:(NSArray<NSString *> *)mediaUids
                    completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows by channel.
 */
- (SRGFirstPageRequest *)radioShowsForChannelWithUid:(NSString *)channelUid
                                     completionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Retrieve the show having the specified uid.
 */
- (SRGRequest *)radioShowWithUid:(NSString *)showUid completionBlock:(SRGShowCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific show.
 *
 *  @param oldestMonth The oldest month for which medias are returned (if `nil`, all medias are returned).
 *
 *  @discussion Though the completion block does not return an array directly, this request supports paging (for episodes returned in the episode
 *              composition).
 */
- (SRGFirstPageRequest *)radioLatestEpisodesForShowWithUid:(NSString *)showUid
                                               oldestMonth:(nullable NSDate *)oldestMonth
                                           completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock;

/**
 *  @name Media composition
 */

/**
 *  Full media information needed to play a media.
 */
- (SRGRequest *)radioMediaCompositionWithUid:(NSString *)mediaUid
                             completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

/**
 *  @name Search
 */

/**
 *  Search medias matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get media objects, call the
 *              `-radioMediasWithUids:completionBlock:` request with the returned search results uid list.
 */
- (SRGFirstPageRequest *)radioMediasMatchingQuery:(NSString *)query
                              withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get media objects, call the
 *              `-audioShowsWithUids:completionBlock:` request with the returned search results uid list.
 */
- (SRGFirstPageRequest *)radioShowsMatchingQuery:(NSString *)query
                             withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (ModuleServices)

/**
 *  @name Modules
 */

/**
 *  List modules for a specific type (e.g. events).
 *
 *  @param moduleType A specific module type.
 */
- (SRGRequest *)modulesWithType:(SRGModuleType)moduleType completionBlock:(SRGModuleListCompletionBlock)completionBlock;

/**
 *  List medias for a specific module type and, optionally, a section from it.
 *
 *  @param moduleType A specific module type.
 *  @param uid        A specific module or section unique identifier.
 *  @param sectionUid An optional section uid.
 */
- (SRGFirstPageRequest *)latestMediasForModuleWithType:(SRGModuleType)moduleType
                                                   uid:(NSString *)uid
                                            sectionUid:(nullable NSString *)sectionUid
                                       completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

/**
 *  Media URL tokenization (common for all business units).
 */
@interface SRGDataProvider (TokenizationServices)

/**
 *  Return the provided URL, tokenized for playback.
 *
 *  @discussion The token is valid for a small amount of time (currently 30 seconds), be sure to use the tokenized URL
 *              as soon as possible.
 */
+ (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
