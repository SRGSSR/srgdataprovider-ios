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
#import "SRGEvent.h"
#import "SRGImageMetadata.h"
#import "SRGLike.h"
#import "SRGMedia.h"
#import "SRGMediaComposition.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGMediaMetadata.h"
#import "SRGMediaParentMetadata.h"
#import "SRGMetadata.h"
#import "SRGPage.h"
#import "SRGPresenter.h"
#import "SRGProgram.h"
#import "SRGRelatedContent.h"
#import "SRGRequest.h"
#import "SRGRequestQueue.h"
#import "SRGResource.h"
#import "SRGSection.h"
#import "SRGSegment.h"
#import "SRGShow.h"
#import "SRGSocialCount.h"
#import "SRGSubtitle.h"
#import "SRGTopic.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

// Official version number
OBJC_EXPORT NSString *SRGDataProviderMarketingVersion(void);

// Official business identifiers
typedef NSString * SRGDataProviderBusinessUnitIdentifier NS_STRING_ENUM;

OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRSI;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTR;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTS;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSRF;
OBJC_EXPORT SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSWI;

// Completion block signatures
typedef void (^SRGChannelListCompletionBlock)(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error);
typedef void (^SRGEpisodeCompositionCompletionBlock)(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGEventListCompletionBlock)(NSArray<SRGEvent *> * _Nullable events, NSError * _Nullable error);
typedef void (^SRGLikeCompletionBlock)(SRGLike * _Nullable like, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error);
typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGShowCompletionBlock)(SRGShow * _Nullable show, NSError * _Nullable error);
typedef void (^SRGShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error);
typedef void (^SRGURLCompletionBlock)(NSURL * _Nullable URL, NSError * _Nullable error);

/**
 *  A data provider supplies metadata for an SRG SSR business unit (media and show lists, mostly). Several data providers 
 *  can coexist in an application, though most application should only require one.
 *
 *  The data provider requests data from the Integration Layer SRG SSRG service, the service responsible of delivering
 *  metadata common to all SRG SSR business units. To avoid unnecessary requests, the data provider relies on the standard
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
 *  To request data, use the methods from the `Services` category. These methods return an `SRGRequest` object, which
 *  lets you manage the request process itself (starting or cancelling data retrieval). 
 *
 *  Requests must be started when needed by calling the `-resume` method, and expect a mandatory completion block, 
 *  called when the request finishes (either normally or with an error).
 *
 *  You can keep a reference to an `SRGRequest` you have started. This can be useful if you later need to cancel the
 *  request, or to start it again. Note that the completion block will not be called if a request is cancelled.
 *
 *  ## Page management
 *
 *  Some services support pagination (retrieving results in pages with a bound number of results for each). Such requests
 *  must always start with the first page of content and proceed by successively retrieving further pages, as follows:
 *
 *  1. Get the `SRGRequest` for a service supporting pagination by calling the associated method from the `Services`
 *     category. Services supporting pagination are easily recognized by looking at their completion block signature, 
 *     which contains a `nextPage` parameter
 *  1. Once the request completes, you obtain a `nextPage` parameter from the completion block. If this parameter is 
 *     not `nil`, you can use it to generate the request for the next page of content, by calling `[request atPage:nextPage]` 
 *     on your previous request, and starting it when needed
 *  1. You can continue requesting further pages until `nil` is returned as `nextPage`, at which point you have
 *     retrieved all available pages of results
 *
 *  Most applications will not directly request the next page of content from the completion block, though. In general,
 *  the `nextPage` could be stored by your application, so that it is readily available when the next request needs
 *  to be generated (e.g. when scrolling reaches the bottom of a result table). You can also directly generate the
 *  next request and store it instead.
 *
 *  Note that you cannot generate arbitrary pages (e.g. you can ask to get the 4th page of content with a page size of 
 *  20 items), as this use case is not supported by Integration Layer services. If you need to reload the whole result 
 *  set, start again with the first request. If results have not changed in the meantime, pages will load in a snap 
 *  thanks to the URL caching mechanism.
 *
 *  ## Request queues
 *
 *  Managing parallel or cascading requests is usually tricky to get right. To make this process as easy as possible,
 *  the data provider library provides a request queue class (`SRGRequestQueue`). Queues group requests and call a
 *  completion block to notify when some of their requests start, or when all requests have ended. Queues let you
 *  manage parallel or cascading requests with a unified formalism, and provide a way to report errors along the way.
 *  For more information, @see `SRGRequestQueue`.
 */
@interface SRGDataProvider : NSObject <NSURLSessionTaskDelegate>

/**
 *  The data provider currently set as shared instance, if any
 *
 *  @see `-setCurrentDataProvider:`
 */
+ (nullable SRGDataProvider *)currentDataProvider;

/**
 *  Set a data provider as shared instance for convenient retrieval via `-currentDataProvider`.
 *
 *  @return The previously installed shared instance, if any
 */
+ (nullable SRGDataProvider *)setCurrentDataProvider:(nullable SRGDataProvider *)currentDataProvider;

/**
 *  Instantiate a data provider
 *
 *  @param serviceURL             The Integration Layer service base URL (which must expose service endpoints
 *                                starting with '/integrationlayer')
 *  @param businessUnitIdentifier The identifier of the SRG SSR business unit to retrieve data for. Use constants
 *                                available at the top of this file for the officially supported values
 */
- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier NS_DESIGNATED_INITIALIZER;

/**
 *  The service URL which has been set
 *
 *  @discussion Always ends with a slash, even if the service URL set at creatoon wasn't
 */
@property (nonatomic, readonly) NSURL *serviceURL;

/**
 *  The business unit identifier which has been set
 */
@property (nonatomic, readonly, copy) NSString *businessUnitIdentifier;

@end

/**
 *  List of the requests supported by the data provider
 */
@interface SRGDataProvider (Services)

/**
 *  List videos which have been picked by editors
 */
- (SRGRequest *)editorialVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List videos which will soon expire
 */
- (SRGRequest *)soonExpiringVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List videos available for the day containing the given date
 *
 *  @param date The date. If nil, today is used
 */
- (SRGRequest *)videoEpisodesForDate:(nullable NSDate *)date withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List trending videos (with all editorial recommendations)
 */
- (SRGRequest *)trendingVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List trending videos. A limit can be set on editorial recommendations and results can be limited to episodes
 *
 *  @param editorialLimit The maximum number of editorial recommendations returned (if nil, all are returned)
 *  @param episodesOnly   Whether only episodes must be returned
 */
- (SRGRequest *)trendingVideosWithEditorialLimit:(nullable NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List video livestreams
 */
- (SRGRequest *)videoLivestreamsWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List audio live streams
 *
 *  @param channelUid The channel uid for which audio live streams (main and regional) must be retrieved. If not specified,
 *                    all main live streams are returned
 */
- (SRGRequest *)audioLivestreamsForChannelWithUid:(nullable NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List video channels
 */
- (SRGRequest *)videoChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  List audio channels
 */
- (SRGRequest *)audioChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  List video topics
 */
- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  List latest videos for a specific topic
 *
 *  @param topicUid The unique topic identifier. If none is specified, medias for any topic will be returned
 */
- (SRGRequest *)latestVideosForTopicWithUid:(nullable NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List latest audios
 */
- (SRGRequest *)latestAudiosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List most popular videos for a specific topic
 *
 *  @param topicUid The unique topic identifier. If none is specified, medias for any topic will be returned
 */
- (SRGRequest *)mostPopularVideosForTopicWithUid:(nullable NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List most popular audios
 *
 *  @param channelUid The channel which medias must be listed for. If none is specified, medias for all channels will be returned
 */
- (SRGRequest *)mostPopularAudiosForChannelWithUid:(nullable NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List events
 */
- (SRGRequest *)eventsWithCompletionBlock:(SRGEventListCompletionBlock)completionBlock;

/**
 *  List videos for a specific event (optionally for a specific section)
 *
 *  @param eventUid   The unique event
 *  @param sectionUid An optional unique section identifier
 */
- (SRGRequest *)latestVideosForEventWithUid:(NSString *)eventUid sectionUid:(nullable NSString *)sectionUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List latest episodes
 *
 *  @param channelUid The channel which medias must be listed for. If none is specified, medias for all channels will be returned
 */
- (SRGRequest *)latestVideoEpisodesForChannelWithUid:(nullable NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List latest audio episodes for a specific channel
 */
- (SRGRequest *)latestAudioEpisodesForChannelWithUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List video shows
 */
- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

/**
 *  List audio shows by channel
 */
- (SRGRequest *)audioShowsForChannelWithUid:(NSString *)channelUid completionBlock:(SRGShowListCompletionBlock)completionBlock;

/**
 *  List episodes for a specific show
 *
 *  @discussion The show can be a video or audio show. Though the completion block does not return an array directly, this request 
 *              supports paging (for episodes returned in the episode composition)
 */
- (SRGRequest *)latestEpisodesForShowWithUid:(NSString *)showUid completionBlock:(SRGEpisodeCompositionCompletionBlock)completionBlock;

/**
 *  List audio episodess available for the day containing the given date, for the specified channel
 *
 *  @param date The date. If nil, today is used
 */
- (SRGRequest *)audioEpisodesForDate:(nullable NSDate *)date withChannelUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Specific show
 */
- (SRGRequest *)showWithUid:(NSString *)showUid completionBlock:(SRGShowCompletionBlock)completionBlock;

/**
 *  Retrieve the full media information needed to play a media
 */
- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

/**
 *  Search videos matching a specific criterium
 *
 *  @discussion Some business units only support full-text search, not partial matching
 */
- (SRGRequest *)searchVideosMatchingQuery:(NSString *)query withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  Increase the SRG popularity like counter from 1 unit for the specified media
 */
- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock;

@end

/**
 *  Media URL tokenization (common for all business units)
 */
@interface SRGDataProvider (Tonekizer)

/**
 *  Return the provided URL, tokenized for playback
 *
 *  @discussion The token is valid for a small amount of time, be sure to use the tokenized URL as soon as possible
 */
+ (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
