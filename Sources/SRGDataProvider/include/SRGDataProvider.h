//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

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
 *  Two similar APIs are provided for data retrieval:
 *    - An API based on SRG Network requets and queues. This API can be used by Objective-C and Swift code for all
 *      supported OS versions.
 *    - A Combine-based API, only callable from Swift code, and which requires iOS 13+, tvOS 13+ or watchOS 6+.
 *
 *  The Combine-based is a modern API providing many benefits (a simple API relying on an official SDK and the possibility
 *  to mix network requets with any kind of asynchronous task using a single formalism). It is now the recommended API if
 *  your project can adopt it.
 *
 *  The SRG Network based API provides APIs with similar philosophy (yet neither functional, nor reactive), most notably
 *  thanks to how requests and queues interact with each other. But since they are limited to network tasks, they do
 *  not offer seamless integration with any kind of asynchronous work (like Combine does), which is why you should prefer
 *  the Combine-based API if you can afford to.
 *
 *  ## Imports
 *
 *  The framework you import depends on the API you intend to use:
 *    - To use the modern Combine API, import `SRGDataProviderCombine`.
 *    - To use the SRG Network based API, import `SRGDataProviderNetwork`.
 *
 *  You can mix both APIs in a single project, though we recommend you choose one and stick with it if you can.
 *
 *  ## Instantiation
 *
 *  You instantiate a data provider with a service URL where all required service endpoints are exposed. Official service
 *  URLs are available at the top of this header file.
 *
 *  In general, a single data provider suffices, which can be used like a singleton by instantiating it early in your
 *  application lifecycle (e.g. in your `-applicationDidFinishLaunching:withOptions:` implementation) and setting it as
 *  global shared instance by using `SRGDataProvider.currentDataProvider`. You can then conveniently retrieve this shared
 *  instance through the same property.
 *
 *  ## Lifetime
 *
 *  A data provider must be retained somewhere, at least when executing a request retrieved from it (otherwise the request
 *  will be automatically cancelled when the data provider is deallocated). You can e.g. use the global shared instance
 *  (see above) or store the data provider you use locally, e.g. at view controller level.
 *
 *  ## Services
 *
 *  The data provider library provides several services to retrieve various kinds of data:
 *    - TV-related services, whose methods start with `tv`. These requests return TV-specific content and require a
 *      business unit to be specified.
 *    - Radio related services (which commonly require a channel identifier to be specified), whose methods start with
 *      `radio`. These requests return radio-specific content and require a business unit to be specified.
 *    - Search services.
 *    - URN-based services.
 *
 *  ## Pagination
 *
 *  Several services support pagination to retrieve more content. You can choose which page size must be used, and SRG
 *  Data Provider will return you additional opaque page objects with which you can retrieve subsequent pages of
 *  result.
 *
 *  Most applications will not directly request the next page of content when they complete, though. In general, the
 *  next page should be stored by your application, so that it is readily available when the next request needs
 *  to be generated (e.g. when scrolling reaches the bottom of a result table).
 *
 *  Note that you cannot generate arbitrary pages (e.g. you can ask to get the 4th page of content with a page size of
 *  20 items), as this use case is not supported by Integration Layer services. If you need to reload the whole result
 *  set, start again with the first request. If results have not changed in the meantime, though, pages will load in a
 *  snap thanks to the URL caching mechanism.
 *
 *  ## Requesting data with Combine
 *
 *  To request data with Combine, use one of the service methods available on `SRGDataProvider` returning a publisher.
 *  Then subscribe to this publisher to receive data and errors, as you would with a usual `NSURLSession` publisher.
 *
 *  Performing requets in a serial or parallel way is achieved entirely using Combine formalism. The SRG Data Provider
 *  Combine framework therefore does not introduce any additional formalism. You should be a bit familiar with Combine or
 *  Functional Reactive Programming (FRP) in general. If not, here are a few useful resources:
 *    - Practical Combine (https://practicalcombine.com/), a friendly introduction to FRP and Combine.
 *    - Using Combine (https://heckj.github.io/swiftui-notes/), an online example-oriented book, but less friendly.
 *
 *  ### Threading considerations
 *
 *  Combine publishers perform work in the background and SRG Data Provider preserves this behavior. If you need your
 *  subscribers to receive results on the main thread (e.g. for UI updates), remember to use the `.receive(on:)`
 *  operator.
 *
 *  ### Requests with pagination support
 *
 *  Publishers for services supporting pagination return a `page` and an optional `nextPage` in their output. These
 *  pages can be used with companion service methods returning the publisher for another page of content.
 *
 *  ## Requesting data with SRG Network
 *
 *  To request data with SRG Network requests, use the `SRGDataProvider` methods available from `Services` header files.
 *  Each method returns one of two possible request types:
 *    - `SRGRequest` instances for standard requests without pagination support.
 *    - `SRGFirstPageRequest` instances for requests supporting pagination.
 *
 *  Requests must be started when needed by calling the `-resume` method, and expect a mandatory completion block,
 *  called when the request finishes (either normally or with an error). You can keep a reference to an `SRGRequest`
 *  you have started to cancel it later if needed. Note that the completion block will not be called when a request
 *  is cancelled.
 *
 *  ### Threading considerations
 *
 *  SRG Network based requests can be started from any thread. By default, their completion block will be called on the
 *  main thread, though. This can be changed by calling `-requestWithOptions:` on an existing request, with the
 *  `SRGNetworkRequestBackgroundThreadCompletionEnabled` option.
 *
 *  This choice has been made to avoid common programming errors. Since all request work is done on background threads,
 *  the completion block is most of the time namely used to trigger UI updates, which have to occur on the main thread.
 *
 *  Note that the Combine API works differently to preserve its asynchronous natural behavior by default.
 *
 *  ### Requests with pagination support
 *
 *  For services supporting pagination. you always start with the first page of content and proceed by successively
 *  retrieving further pages, as follows:
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
 *  ### Request queues
 *
 *  Managing parallel or cascading requests is usually tricky to get right. To make this process as easy as possible,
 *  the SRG Network library provides a request queue class (`SRGRequestQueue`). Queues group requests and call a
 *  completion block to notify when some of them start, or when all requests have ended. Queues let you manage parallel
 *  or cascading requests with a unified formalism, and provide a way to report errors along the way. For more information,
 *  please have a look at SRG Network documentation.
 *
 *  ## Service availability
 *
 *  Service availability depends on the business unit. Have a look at the `Documentation/Service-availability.md` file
 *  supplied with this project documentation for more information.
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
