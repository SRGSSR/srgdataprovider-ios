//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

// Public framework imports.
#import "SRGAlbum.h"
#import "SRGArtist.h"
#import "SRGBaseTopic.h"
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
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGModule.h"
#import "SRGModuleIdentifierMetadata.h"
#import "SRGPage.h"
#import "SRGPageRequest.h"
#import "SRGPresenter.h"
#import "SRGProgram.h"
#import "SRGRelatedContent.h"
#import "SRGRequest.h"
#import "SRGRequestQueue.h"
#import "SRGResource.h"
#import "SRGScheduledLivestreamMetadata.h"
#import "SRGSearchResult.h"
#import "SRGSearchResultMedia.h"
#import "SRGSearchResultShow.h"
#import "SRGSection.h"
#import "SRGSegment.h"
#import "SRGShow.h"
#import "SRGShowIdentifierMetadata.h"
#import "SRGSocialCount.h"
#import "SRGSocialCountOverview.h"
#import "SRGSong.h"
#import "SRGSubdivision.h"
#import "SRGSubtitle.h"
#import "SRGSubtopic.h"
#import "SRGTopic.h"
#import "SRGTopicIdentifierMetadata.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

// Official version number.
OBJC_EXPORT NSString *SRGDataProviderMarketingVersion(void);

// Official service URLs.
OBJC_EXPORT NSURL *SRGIntegrationLayerProductionServiceURL(void);
OBJC_EXPORT NSURL *SRGIntegrationLayerStagingServiceURL(void);
OBJC_EXPORT NSURL *SRGIntegrationLayerTestServiceURL(void);

// Official business identifiers.
typedef NSString * SRGDataProviderBusinessUnit NS_STRING_ENUM;

OBJC_EXPORT SRGDataProviderBusinessUnit const SRGDataProviderBusinessUnitRSI;
OBJC_EXPORT SRGDataProviderBusinessUnit const SRGDataProviderBusinessUnitRTR;
OBJC_EXPORT SRGDataProviderBusinessUnit const SRGDataProviderBusinessUnitRTS;
OBJC_EXPORT SRGDataProviderBusinessUnit const SRGDataProviderBusinessUnitSRF;
OBJC_EXPORT SRGDataProviderBusinessUnit const SRGDataProviderBusinessUnitSWI;

// Completion block signatures (without pagination support).
typedef void (^SRGChannelCompletionBlock)(SRGChannel * _Nullable channel, NSError * _Nullable error);
typedef void (^SRGChannelListCompletionBlock)(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error);
typedef void (^SRGMediaCompletionBlock)(SRGMedia * _Nullable media, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error);
typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error);
typedef void (^SRGModuleListCompletionBlock)(NSArray<SRGModule *> * _Nullable modules, NSError * _Nullable error);
typedef void (^SRGShowCompletionBlock)(SRGShow * _Nullable show, NSError * _Nullable error);
typedef void (^SRGShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error);
typedef void (^SRGSocialCountOverviewCompletionBlock)(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error);
typedef void (^SRGSongCompletionBlock)(SRGSong * _Nullable song, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error);
typedef void (^SRGURLCompletionBlock)(NSURL * _Nullable URL, NSError * _Nullable error);

// Completion block signatures (with pagination support). For requests supporting it, the total number of results is returned.
typedef void (^SRGPaginatedEpisodeCompositionCompletionBlock)(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedSearchResultMediaListCompletionBlock)(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, NSNumber *total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedSearchResultShowListCompletionBlock)(NSArray<SRGSearchResultShow *> * _Nullable searchResults, NSNumber *total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGPaginatedSongListCompletionBlock)(NSArray<SRGSong *> * _Nullable songs, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);

/**
 *  A data provider supplies metadata for all SRG SSR business units (media and show lists, mostly). Several data providers
 *  can coexist in an application, though most applications should only require one.
 *
 *  The data provider requests data from the Integration Layer, the SRG SSR service responsible of delivering metadata
 *  common to all SRG SSR business units. To avoid unnecessary requests, the data provider relies on the standard
 *  built-in iOS URL cache (`NSURLCache`). No additional application setup is required.
 *
 *  ## Instantiation
 *
 *  You instantiate a data provider with a service base URL. The service URL must expose services whose endpoints start
 *  with 'integrationlayer/', corresponding to a working Integration Layer installation. Official server URLs are available
 *  at the top of this header files.
 *
 *  In general, a single data provider suffices, which can be used like a singleton by instantiating it early in your application
 *  lifecycle (e.g. in your `-applicationDidFinishLaunching:withOptions:` implementation) and setting it as global shared instance
 *  by calling `-[SRGDataProvider setCurrentDataProvider:]`. You can then conveniently retrieve this shared instance with
 *  `-[SRGDataProvider currentDataProvider]`.
 *
 *  ## Lifetime
 *
 *  A data provider must be retained somewhere, at least when executing a request retrieved from it (otherwise the request
 *  will be automatically cancelled when the data provider is deallocated). You can e.g. use the global shared instance
 *  (see above) or store the data provider you use locally, e.g. at view controller level.
 *
 *  ## Thread-safety
 *
 *  The data provider library does not make any guarantees regarding thread safety. Though highly asynchronous in nature
 *  during data retrieval and parsing, the library components and methods are meant to be used from the main thread only.
 *  Data provider creation and requests must be performed from the main thread. Accordingly, completion blocks are guaranteed
 *  to be called on the main thread as well.
 *
 *  This choice was made to prevent programming errors, since requests will usually be triggered by user interactions,
 *  and result in the UI being updated. Trying to use this library from any other thread except the main one will result
 *  in undefined behavior (i.e. it may work or not, and may or not break in the future).
 *
 *  ## Service availability
 *
 *  Service availability depends on the business unit. Have a look at the `Documentation/Service-availability.md` file
 *  supplied with this project documentation for more information.
 *
 *  ## Requesting data
 *
 *  To request data, use the methods from the various 'Services' category. These methods return an request objects which
 *  let you manage the request process itself (starting or cancelling data retrieval), and are basically separated in
 *  several major groups:
 *    - TV-related services, whose methods start with `tv`. These requests return TV-specific content and require a
 *      business unit to be specified.
 *    - Radio related services (which commonly require a channel identifier to be specified), whose methods start with
 *      `radio`. These requests return radio-specific content and require a business unit to be specified.
 *    - Search services, whose methods start with `video` or `audio. These requests require a business unit to be specified
 *      Note that radio channels sometimes also provide content as videos.
 *    - URN-based services.
 *    - Token retrieval services.
 *
 *  Data provider methods return two kinds of request objects:
 *    - `SRGRequest` instances for standard requests without pagination support.
 *    - `SRGFirstPageRequest` instances for requests supporting pagination.
 *
 *  Requests must be started when needed by calling the `-resume` method, and expect a mandatory completion block,
 *  called when the request finishes (either normally or with an error). You can keep a reference to an `SRGRequest`
 *  you have started to cancel it later if needed. Note that the completion block will not be called when a request
 *  is cancelled.
 *
 *  ## Requests with pagination support
 *
 *  Some services support pagination (retrieving results in pages with a bound number of results for each). Such requests
 *  always start with the first page of content and proceed by successively retrieving further pages, as follows:
 *
 *  1. Get the `SRGFirstPageRequest` from a service method supporting pagination. Keep a local reference to this initial
 *     request and perform it by calling `-resume` on it.
 *  1. Once the request completes, you obtain a `nextPage` parameter from the completion block. If this parameter is
 *     not `nil`, you can use it to generate the request for the next page of content. This is achieved by calling
 *     the `-[SRGFirstPageRequest requestWithPage:]` method on the initial request you kept a reference to. You must
 *     call `-resume` on this new request to start it, as usual.
 *  1. You can continue requesting further pages until `nil` is returned as `nextPage`, at which point you have
 *     retrieved all available pages of results.
 *
 *  Most applications will not directly request the next page of content from the completion block, though. In general,
 *  the `nextPage` could be stored by your application, so that it is readily available when the next request needs
 *  to be generated (e.g. when scrolling reaches the bottom of a result table).
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
 */
- (instancetype)initWithServiceURL:(NSURL *)serviceURL NS_DESIGNATED_INITIALIZER;

/**
 *  The service URL which has been set.
 *
 *  @discussion Always ends with a slash, even if the service URL set at creation wasn't.
 */
@property (nonatomic, readonly) NSURL *serviceURL;

/**
 *  Optional global headers which will added to all requests.
 */
@property (nonatomic, nullable) NSDictionary<NSString *, NSString *> *globalHeaders;

@end

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
- (SRGRequest *)tvChannelsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                      withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific TV channel. Use this request to obtain complete channel information, including current and next programs).
 *
 *  Please https://github.com/SRGSSR/srgdataprovider-ios/wiki/Channel-information for more information about this method.
 */
- (SRGRequest *)tvChannelForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                 withUid:(NSString *)channelUid
                         completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  List of TV livestreams.
 */
- (SRGRequest *)tvLivestreamsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                         withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List of TV scheduled livestreams.
 */
- (SRGFirstPageRequest *)tvScheduledLivestreamsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                           withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Medias which have been picked by editors.
 */
- (SRGFirstPageRequest *)tvEditorialMediasForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                      withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Medias which will soon expire.
 */
- (SRGFirstPageRequest *)tvSoonExpiringMediasForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Trending medias (with all editorial recommendations).
 *
 *  @param limit The maximum number of results returned (if `nil`, 10 results at most will be returned).
 */
- (SRGRequest *)tvTrendingMediasForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
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
- (SRGRequest *)tvTrendingMediasForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                      withLimit:(nullable NSNumber *)limit
                                 editorialLimit:(nullable NSNumber *)editorialLimit
                                   episodesOnly:(BOOL)episodesOnly
                                completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes.
 */
- (SRGFirstPageRequest *)tvLatestEpisodesForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for the day containing the given date.
 *
 *  @param date The date. If `nil`, today is used.
 */
- (SRGFirstPageRequest *)tvEpisodesForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                              date:(nullable NSDate *)date
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Topics
 */

/**
 *  Topics.
 */
- (SRGRequest *)tvTopicsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                    withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows.
 */
- (SRGFirstPageRequest *)tvShowsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                            withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching.
 */
- (SRGFirstPageRequest *)tvShowsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                  matchingQuery:(NSString *)query
                            withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock;

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
- (SRGRequest *)radioChannelsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                         withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific radio channel. Use this request to obtain complete channel information, including current and next programs).
 *
 *  Please https://github.com/SRGSSR/srgdataprovider-ios/wiki/Channel-information for more information about this method.
 *
 *  @param livestreamUid An optional radio channel unique identifier (usually regional, but might be the main one). If provided,
 *                       the program of the specified live stream is used, otherwise the one of the main channel.
 */
- (SRGRequest *)radioChannelForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                             withChannelUid:(NSString *)channelUid
                              livestreamUid:(nullable NSString *)livestreamUid
                            completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  List of radio livestreams for a channel.
 *
 *  @param channelUid The channel uid for which audio livestreams (main and regional) must be retrieved.
 */
- (SRGRequest *)radioLivestreamsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List of radio livestreams.
 *
 *  @param contentProviders The content providers to return radio livestreams for.
 */
- (SRGRequest *)radioLivestreamsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                               contentProviders:(SRGContentProviders)contentProviders
                            withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Latest medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestMediasForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                               channelUid:(NSString *)channelUid
                                      withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioMostPopularMediasForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                                    channelUid:(NSString *)channelUid
                                           withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestEpisodesForForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                                    channelUid:(NSString *)channelUid
                                           withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for the day containing the given date, for the specific channel.
 *
 *  @param date The date. If `nil`, today is used.
 */
- (SRGFirstPageRequest *)radioEpisodesForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                                 date:(nullable NSDate *)date
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest video medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestVideosForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                               channelUid:(NSString *)channelUid
                                      withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows by channel.
 */
- (SRGFirstPageRequest *)radioShowsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                        channelUid:(NSString *)channelUid
                               withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching.
 */
- (SRGFirstPageRequest *)radioShowsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                     matchingQuery:(NSString *)query
                               withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock;

/**
 *  @name Song list
 */

/**
 *  Song list by channel.
 */
- (SRGFirstPageRequest *)radioSongsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                        channelUid:(NSString *)channelUid
                               withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock;

/**
 *  Current song by channel.
 *
 *  @discussion If no song is currently being played, the completion block is called with both song and error set to `nil`.
 */
- (SRGRequest *)radioCurrentSongForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGSongCompletionBlock)completionBlock;

@end

/**
 *  List of online-oriented services supported by the data provider.
 */
@interface SRGDataProvider (OnlineServices)

/**
 *  @name Shows
 */

/**
 *  Shows.
 */
- (SRGFirstPageRequest *)onlineShowsForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

@end

/**
 *  List of services offered by the SwissTXT Live Center.
 */
@interface SRGDataProvider (LiveCenterServices)

/**
 *  List of videos available from the Live Center.
 */
- (SRGFirstPageRequest *)liveCenterVideosForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

/**
 *  List of media search-oriented services supported by the data provider.
 */
@interface SRGDataProvider (MediaSearchServices)

/**
 *  Search videos matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get media objects, call the
 *              `-videosWithUids:completionBlock:` request with the returned search results uid list.
 */
- (SRGFirstPageRequest *)videosForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                 matchingQuery:(NSString *)query
                           withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock;

/**
 *  Search audios matching a specific query.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get media objects, call the
 *              `-audiosWithUids:completionBlock:` request with the returned search results uid list.
 */
- (SRGFirstPageRequest *)audiosForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                 matchingQuery:(NSString *)query
                           withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock;

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
- (SRGRequest *)modulesForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                  type:(SRGModuleType)moduleType
                   withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock;

@end

/**
 *  List of services for popularity measurements supported by the data provider.
 */
@interface SRGDataProvider (PopularityServices)

/**
 *  Increase the specified social count from 1 unit for the specified subdivision.
 */
- (SRGRequest *)increaseSocialCountForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                              type:(SRGSocialCountType)type
                                       subdivision:(SRGSubdivision *)subdivision
                               withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock;

/**
 *  Increase the specified social count from 1 unit for the specified media composition.
 */
- (SRGRequest *)increaseSocialCountForBusinessUnit:(SRGDataProviderBusinessUnit)businessUnit
                                              type:(SRGSocialCountType)type
                                  mediaComposition:(SRGMediaComposition *)mediaComposition
                               withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock;

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
 *  @discussion The list must contain at least a URN, otherwise the result is undefined. Partial results can be
 *              returned if some URNs (but not all) are invalid. Note that you cannot mix audio and video URNs,
 *              or URNs from different business units, otherwise the request will fail.
 */
- (SRGRequest *)mediasWithURNs:(NSArray<NSString *> *)mediaURNs
               completionBlock:(SRGMediaListCompletionBlock)completionBlock;

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
 *  @param chaptersOnly If set to `YES`, the returned media composition is only made of chapters. If set to `NO`, it
 *                      may contain a mixture of chapters and segments.
 */
- (SRGRequest *)mediaCompositionWithURN:(NSString *)mediaURN
                           chaptersOnly:(BOOL)chaptersOnly
                        completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

/**
 *  Retrieve the show having the specified URN.
 */
- (SRGRequest *)showWithURN:(NSString *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific show.
 *
 *  @param maximumPublicationMonth If not `nil`, medias up to the specified month are returned.
 *
 *  @discussion Though the completion block does not return an array directly, this request supports paging (for episodes
 *              returned in the episode composition object). Unlike the equivalent TV and radio requests, this request
 *              does not support an optional date to filter only more recent media.
 */
- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(NSString *)showURN
                              maximumPublicationMonth:(nullable NSDate *)maximumPublicationMonth
                                      completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock;

/**
 *  List medias for a specific module.
 */
- (SRGFirstPageRequest *)latestMediasForModuleWithURN:(NSString *)moduleURN
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
 *              as soon as possible. The returned URL might be the same as the input URL when no tokenization was
 *              required.
 */
+ (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
