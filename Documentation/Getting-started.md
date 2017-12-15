Getting started
===============

This getting started guide discusses all concepts required to use the SRG Data Provider library. It covers basic topics like data provider instantiation and requests, as well as more advanced topics like request queues and pagination.

## Data provider instantation and access

At its core, the SRG Data Provider library reduces to a single data provider class, `SRGDataProvider`, which you instantiate for a business unit and a service URL, for example:

```objective-c
SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
```

A set of constants for common service URLs (production, staging and test) and business unit identifiers is provided. You can have several data providers in an application, most notably if you want to gather data from different business units from the same application. 

In general, though, most applications should only need a single data provider, since they probably target one business unit only. To make it easier to access the main data provider throughout your application, the `SRGDataProvider` class provides class methods to set it as shared instance:

```objective-c
SRGDataProvider *dataProvider = ...;
[SRGDataProvider setCurrentDataProvider:dataProvider];
```

and to retrieve it from anywhere, for example when creating a request:

```objective-c
SRGDataProvider *dataProvider = [SRGDataProvider currentDataProvider];
```

For simplicity, this getting started guide assumes that a shared data provider has been set. If you cannot use the shared instance, store the data providers you instantiated somewhere and provide access to them in some way.

## Requesting data

To request data, use the methods available from one of the `SRGDataProvider` _Services_ category. All service methods return an `SRGRequest` instance (or an instance of a subclass thereof), providing you with a common interface to manage requests.

For example, to get the list of TV livestreams, simply call:

```objective-c
SRGRequest *request = [[SRGDataProvider currentDataProvider] tvLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
    if (error) {
        // Deal with the error
        return;
    }
    
    // Proceed further, e.g. display the medias
}];
[request resume];
```

A request is started by calling `-resume` and can be cancelled with a `-cancel`. When a request ends, the corresponding completion block is called, with the returned data or error information. The completion block of a cancelled request will not be called, though.

### Lifetime

A request retains itself when running and can therefore be executed as described above, but in general you should store a reference to any request you perform so that you can cancel it when appropriate. Simply performing requests out of the blue can be considered bad practice and should be avoided.

Usually requests are made at the view controller level, which is why you should keep some reference to a request from within your view controller implementation:

```objective-c
@interface MyViewController ()
@property (nonatomic) SRGRequest *request;
@end
```

Set this request property when a refresh is performed:

```objective-c
- (void)refresh
{
    self.request = [[SRGDataProvider currentDataProvider] tvLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        // ....
    }];
    [self.request resume];
}
```

and use this reference to cancel it when the view controller disappears:

```objective-c
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self isMovingFromParentViewController] || [self isBeingDismissed]) {
        [self.request cancel];
    }
}
```

#### Remark

If `self` retains the request and is referenced from its completion block, you will create a retain cycle since the block captures its context, which `self` is implicitly part of. To eliminate those issues, be sure to create a weak reference to `self` where needed, e.g.

```objective-c
- (void)refresh
{
    __weak __typeof(self) weakSelf = self;
    self.request = [[SRGDataProvider currentDataProvider] tvLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        [weakSelf doStuff];
    }];
    [self.request resume];
}
```

For Objective-C codebases, you can use the bundled `libextobjc` framework which provides expressive convenience macros for this purpose:

```objective-c
#import <libextobjc/libextobjc.h>

- (void)refresh
{
    @weakify(self)
    self.request = [[SRGDataProvider currentDataProvider] tvLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        @strongify(self)
        [self doStuff];
    }];
    [self.request resume];
}
```

### Request availability

Request availability depends on the business unit. Refer to the provided [compatibility matrix](Service-availability.md) for reference.

## Pagination

Pagination is a way to retrieve results in pages of constrained size, e.g. 20 items at most per page. All requests which return an `SRGFirstPageRequest` instance support pagination. Refer to the [service matrix](`Documentation/Service-availability.md`) for more information about pagination availability and page size constraints. By default, services use a page size of 10 items.

### Fundamentals 

Services do not provide direct random access to a page of content. Instead, a first page of content must be retrieved, which might reference a link to the next page of content, and so on. By following the sequence of next page links, all content can therefore be retrieved, page after page.

The data provider library reflects the way pagination works through two `SRGRequest` subclasses:

* `SRGPageRequest`, which represents a request for some page of content.
* `SRGFirstPageRequest`, which represents the initial request needed to load the first page of content. Note that `SRGFirstPageRequest` is itself a subclass of `SRGPageRequest`.

### Retrieving pages of content

Data provider services which support pagination return an `SRGFirstPageRequest` instance, with which the first page of results with default size can be obtained. The request can be peformed as is if this matches your needs, but you can also:

* Request more or less results per page by calling `-requestWithPageSize:`, which returns a new `SRGFirstPageRequest` you can then execute.
* Request another page of content by calling `-requestWithPage:`, which returns a new `SRGPageRequest` you can then execute.

Since `SRGPageRequest` instances do not support calling `-requestWithPage:`, you must store a reference to the first page somehow, so that you can use it to generate the subsequent page requests when needed.

When calling `-requestWithPage:`, a page parameter of type `SRGPage` must be supplied. Since direct access to a page is not possible, `SRGPage` instances are instantiated and provided by the library, not in client code, and returned when a completion block is called.

Here is a simple illustration of the way page retrieval conceptually works:

```objective-c
SRGFirstPageRequest *request = [[SRGDataProvider currentDataProvider] tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
   if (error) {
       // Deal with the error
       // ...
       return;
   }
    
   // Append medias to some list
   // ...
    
   // Request the next page of content, if any
   if (nextPage) {
      SRGPageRequest *nextPageRequest = [request requestWithPage:nextPage];
      [nextPageRequest resume];
   }
}];
[request resume];
```

This implementation is meant for illustration purposes only since it has two major drawbacks:

* Requests are performed one after another, which can be catastrophic if a lot of pages are available. Usually, you shoukld wait until the current result set has been browsed before loading the next page.
* There is no way to cancel the requests once started.

To solve those issues and properly implement pagination support in your application, you should use a request queue.

## Request queues

You often need to perform related requests together. To make this process as straightforward as possible, the SRG SSR data provider library supplies an `SRGRequestQueue` utility class.

A request queue is a group of requests which is considered to be running when at least one request it is associated with is running. When toggling between running and non-running states, the queue calls an optional block, which makes it easy to perform actions related to the global request execution (e.g. updating the user interface). During the course of request execution, the block might be called several times, as the queue might switch several times between running and non-running states.

Requests can be added at any time to an existing queue, whose state will be immediately updated accordingly. If errors are encountered along the way, requests can also report errors to the queue, so that these errors can be consolidated and reported once.

### Instantiation and lifetime

Unlike requests, queues do not automatically retain themselves when running. This would namely lead to subtle premature deallocation issues, since a queue is intended to be able to toggle several times between running and non-running states. Your code must therefore strongly reference a request queue while in use.

Usually requests are made at the view controller level, which is why you should keep a reference to a request queue from within your view controller implementation:

```objective-c
@interface MyViewController ()
@property (nonatomic) SRGRequestQueue *requestQueue;
@end
```

Create a fresh request queue when a refresh is performed, and assign it to this property to keep it alive:

```objective-c
- (void)refresh
{
    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        if (finished) {
            // Called when the queue switches from runnning to non-running
        }
        else {
            // Called when the queue switches from non-running to running
        }
    }];

    // ...
}
```

An optional state change block can be provided, and is called when the queue toggles between running and non-running states. The state change block can for example be used to display a spinner while the queue is running, or to reload a table of results once the queue finishes.

Once you have a queue, you can add requests to it at any time. In general, requests will be added in parallel or in cascade (see below). You can also cancel a queue, which will cancel all requests related to it, e.g. when your view controller disappears:

```objective-c
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self isMovingFromParentViewController] || [self isBeingDismissed]) {
        [self.requestQueue cancel];
    }
}
```

#### Remark

Requests added to a queue do not need to be additionally retained elsewhere. They are automatically retained _with_ the queue and cancelled when the queue is cancelled. Not that requests are not internally retained _by_ the queue, which means no retain cycle will occur if you reference a queue from within a request completion block (which is the pattern enforced by error reporting, see below). No `__weak` reference to the queue is therefore required.

### Parallel requests

If a request does not depend on the result of another request (e.g. requesting editorial and trending medias at the same time), you can instantiate both requests at the same level and add them to a common queue by calling `-addRequest:resume:`:

```objective-c
- (void)refresh
{
    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        if (finished) {
            // Proceed with the results, e.g. use self.editorialMedias and self.trendingMedias to 
            // reload a table or collection view. If errors have been reported to the queue, they 
            // will be available here
        }
        else {
            // Display a spinning wheel, for example
        }
    }];
    
    // Results are stored in additional NSArray properties for editorial and trending medias
    SRGRequest *editorialRequest = [[SRGDataProvider currentDataProvider] tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        self.editorialMedias = medias;
    }];
    [requestQueue addRequest:editorialRequest resume:YES];
    
    SRGRequest *trendingRequest = [[SRGDataProvider currentDataProvider] tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        self.trendingMedias = medias;
    }];
    [requestQueue addRequest:trendingRequest resume:YES];
}
```

When adding requests to a queue, you can have them automatically started by setting the `resume` parameter to `YES`. If you set it to `NO`, you can still start the queue later by calling `-resume` on it. 

Each individual request completion block might receive an error. To propagate errors to the parent queue, completion block implementations should call `-reportError:` on the queue. You do not need to check whether the error to be reported is `nil` or not: If error is `nil`, no error will be reported. Once the queue completes, the consolidated error information, built from all errors reported to the queue when it was running, will be available. 

#### Remark

Though `__weak` request queue references are not required, you must still weakify `self` if referenced in the state change block of a queue it retains, otherwise you will create a retain cycle:

```objective-c
- (void)refresh
{
    __weak __typeof(self) weakSelf = self;
    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        [weakSelf doStuff];
    }];
    
    // ...
}
```

or, with the `libextobjc` framework:

```objective-c
- (void)refresh
{
    @weakify(self)
    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        @strongify(self)
        [self doStuff];
    }];
    
    // ...
}
```

### Cascading requests

If a request depends on the result of another request, you can similarly use a request queue to bind them together. For example, if you want to retrieve the media composition corresponding to the first editorial video, you must nest requests since getting the correct media composition requires knowledge of the first media identifier:

```objective-c
- (void)refresh
{
    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        // ...
    }];

    SRGRequest *editorialRequest = [[SRGDataProvider currentDataProvider] tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            [requestQueue reportError:error];
            return;
        }
        
        SRGMedia *firstMedia = medias.firstObject;
        SRGRequest *mediaCompositionRequest = [[SRGDataProvider currentDataProvider] videoCompositionWithUid:firstMedia.uid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
             if (error) {
                [requestQueue reportError:error];
                return;
             }
        
             // Do something with the media composition
        }];
        [self.requestQueue addRequest:mediaCompositionRequest resume:YES];
    }];
    [self.requestQueue addRequest:editorialRequest resume:YES];
}
```

### Pagination

Pagination is a special case of cascading requests, since the page information retrieved from a page request is used to build the request for the next page. Requests cannot be immediately linked together, though, otherwise all pages would be retrieved in a single batch, which is not how pagination is supposed to work. The request for an additional page of content must namely be related to some kind of user interaction, whether a table view was scrolled to its bottom, or the user tapped on a button to load more content. 

A single request queue can be used to implement on-demand page loading, thanks to the possibility to add a request to a queue at any time. You only need to store the next page information alongside the queue and the first page request, so that this information is available when the next page of content must be retrieved. You might also want to store a mapping of the results per page so that you can consolidate results as new content is made available:

```
@interface MyViewController ()
@property (nonatomic) SRGRequestQueue *requestQueue;
@property (nonatomic) SRGFirstPageRequest *firstPageRequest;
@property (nonatomic) SRGPage *nextPage;
@property (nonatomic) NSMutableDictionary<SRGPage *, NSArray<SRGMedia *> *> *medias;
@end
```

Note that `SRGMedia` objects can be used as dictionary keys.

When a full refresh is needed, create the first request and a queue which will receive all page requests:

```objective-c
- (void)refresh
{
    self.medias = [NSMutableDictionary dictionary];
    self.nextPage = nil;

    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        if (finished) {
            // Consolidate the self.medias dictionary and display results, or deal with errors
        }
        else {
            // Display a spinning wheel, for example
        }
    }];

    self.firstPageRequest = [[SRGDataProvider currentDataProvider] tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            [self.requestQueue reportError:error];
            return;
        }
        
        self.medias[page] = medias;
        self.nextPage = nextPage;
    }];
    [self.requestQueue addRequest:self.request resume:YES];
```

When you need to load the next page of content (if any is available), simply generate the next page request and add it to the queue:

```objective-c
- (void)loadNextPage
{
    if (self.nextPage) {
        SRGPageRequest *request = [self.firstPageRequest requestWithPage:self.nextPage];
        [self.requestQueue addRequest:request resume:YES];
    }
}
```

## Token

To play media URLs received in `SRGMediaComposition` objects, you need to retrieve a token, otherwise you will receive an unauthorized error. A special class method is provided on `SRGDataProvider` for this very special purpose:

```objective-c
NSURL *mediaURL = ...;   // This information can be retrieved from an `SRGMediaComposition`
[[SRGDataProvider tokenizeURL:mediaURL withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
    // Play the URL with a media player
}] resume];
```

## Thread-safety

The library was not designed to be thread-safe. Though data retrieval occurs asynchronously, requests are expected to be started from the main thread. Accordingly, completion blocks are guaranteed to be executed on the main thread as well.

## App Transport Security (ATS)

In a near future, Apple will favor HTTPS over HTTP, and require applications to explicitly declare potentially insecure connections. These guidelines are referred to as [App Transport Security (ATS)](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33).

For information about how you should configure your application to access our services, please refer to the dedicated [wiki topic](https://github.com/SRGSSR/srgdataprovider-ios/wiki/App-Transport-Security-(ATS)).
