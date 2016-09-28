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
#import "SRGEvent.h"
#import "SRGImageMetadata.h"
#import "SRGLike.h"
#import "SRGMedia.h"
#import "SRGMediaComposition.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGMediaMetadata.h"
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

// Project version information
OBJC_EXPORT double SRGDataProviderVersionNumber;
OBJC_EXPORT const unsigned char SRGDataProviderVersionString[];

// Official version number
OBJC_EXPORT NSString *SRGDataProviderMarketingVersion(void);

// Official business identifiers
OBJC_EXPORT NSString * const SRGDataProviderBusinessUnitIdentifierRSI;
OBJC_EXPORT NSString * const SRGDataProviderBusinessUnitIdentifierRTR;
OBJC_EXPORT NSString * const SRGDataProviderBusinessUnitIdentifierRTS;
OBJC_EXPORT NSString * const SRGDataProviderBusinessUnitIdentifierSRF;
OBJC_EXPORT NSString * const SRGDataProviderBusinessUnitIdentifierSWI;

// Completion block signatures
typedef void (^SRGChannelListCompletionBlock)(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error);
typedef void (^SRGEventListCompletionBlock)(NSArray<SRGEvent *> * _Nullable events, NSError * _Nullable error);
typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error);
typedef void (^SRGURLCompletionBlock)(NSURL * _Nullable URL, NSError * _Nullable error);
typedef void (^SRGLikeCompletionBlock)(SRGLike * _Nullable like, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error);

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
// TODO: Document: completion block never called for cancelled requests
// TODO: Maybe have an audio / video enum parameter for each method available for audio & videos
@interface SRGDataProvider (Services)

- (SRGRequest *)editorialVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)soonExpiringVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)videosForDate:(nullable NSDate *)date withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)trendingVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)trendingVideosWithEditorialLimit:(nullable NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)videoChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

- (SRGRequest *)latestVideosWithTopicUid:(nullable NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)mostPopularVideosWithTopicUid:(nullable NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)eventsWithCompletionBlock:(SRGEventListCompletionBlock)completionBlock;
- (SRGRequest *)latestVideosForEventWithUid:(NSString *)eventUid sectionUid:(nullable NSString *)sectionUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

- (SRGRequest *)searchVideosMatchingQuery:(NSString *)query withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock;

- (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
