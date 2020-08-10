//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The default page size.
 */
static const NSUInteger SRGDataProviderDefaultPageSize = 10;

/**
 *  The maximum supported page size.
 */
static const NSUInteger SRGDataProviderMaximumPageSize = 100;

/**
 *  Unlimited page size (i.e. all results are returned). Not available for all services.
 */
static const NSUInteger SRGDataProviderUnlimitedPageSize = NSUIntegerMax;

// Official version number.
OBJC_EXPORT NSString *SRGDataProviderMarketingVersion(void);

// Official service URLs.
OBJC_EXPORT NSURL *SRGIntegrationLayerProductionServiceURL(void);
OBJC_EXPORT NSURL *SRGIntegrationLayerStagingServiceURL(void);
OBJC_EXPORT NSURL *SRGIntegrationLayerTestServiceURL(void);

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
 *  You instantiate a data provider with a service URL where all required service endpoints are exposed. Official service URLs
 *  are available at the top of this header file.
 *
 *  In general, a single data provider suffices, which can be used like a singleton by instantiating it early in your application
 *  lifecycle (e.g. in your `-applicationDidFinishLaunching:withOptions:` implementation) and setting it as global shared instance
 *  by setting `SRGDataProvider.currentDataProvider`. You can then conveniently retrieve this shared instance through
 *  the same property.
 *
 *  ## Lifetime
 *
 *  A data provider must be retained somewhere, at least when executing a request retrieved from it (otherwise the request
 *  will be automatically cancelled when the data provider is deallocated). You can e.g. use the global shared instance
 *  (see above) or store the data provider you use locally, e.g. at view controller level.
 *
 *  ## Thread-safety
 *
 *  Data provider requests can be started from any thread. By default, their completion block will be called on the main
 *  thread, though. This can be changed by calling `-requestWithOptions:` on an existing request, with the
 *  `SRGNetworkRequestBackgroundThreadCompletionEnabled` option.
 *
 *  This choice has been made to avoid common programming errors. Since all request work is done on background threads,
 *  the completion block is most of the time namely used to trigger UI updates, which have to occur on the main thread.
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
 */
@property (class, nonatomic, nullable) SRGDataProvider *currentDataProvider;

/**
 *  Instantiate a data provider.
 *
 *  @param serviceURL The service URL to use. Official service URLs are available at the top of this header file.
 */
- (instancetype)initWithServiceURL:(NSURL *)serviceURL NS_DESIGNATED_INITIALIZER;

/**
 *  The service URL which has been set.
 */
@property (nonatomic, readonly) NSURL *serviceURL;

/**
 *  The session used to perform the requests.
 */
@property (nonatomic, readonly) NSURLSession *session;

/**
 *  Optional global headers which will added to all requests. Use with caution, as some headers might not be supported and
 *  could lead to request failure.
 */
@property (nonatomic, nullable) NSDictionary<NSString *, NSString *> *globalHeaders;

/**
 *  Optional global parameters which will added to all requests. Use with caution, as some parameters might not be supported
 *  and could lead to request failure.
 */
@property (nonatomic, nullable) NSDictionary<NSString *, NSString *> *globalParameters;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
