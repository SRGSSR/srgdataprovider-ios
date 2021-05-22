Getting started
===============

This getting started guide discusses all concepts required to use the SRG Data Provider library.

## Data provider instantation and access

At its core the SRG Data Provider library reduces to a single data provider class, `SRGDataProvider`, which you instantiate for a service URL, for example in Swift:

```swift
let dataProvider = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
```

or in Objective-C:

```objective-c
SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
```

A set of constants for common service URLs (production, staging and test) is provided. You can have several data providers in an application, though most applications should require only one. To make it easier to access the main data provider of an application, the `SRGDataProvider` class provides a class property to set and retrive it as shared instance in in Swift:

```swift
SRGDataProvider.current = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
```

or in Objective-C:

```objective-c
SRGDataProvider.currentDataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
```

For simplicity this getting started guide assumes that a shared data provider has been set. Note that all requests associated with a data provider will be cancelled if it gets deallocated. If you cannot or don't want to use the shared instance, you must therefore store the data providers you instantiated somewhere and provide access to them in some other way. 

## Combine data publishers

The `SRGDataProviderCombine` library provides Combine publishers for each supported request, 
When subscribing to an SRG Data Provider publisher the corresponding request is performed and results are delivered to the associated pipeline.

SRG Data Provider offers two kinds of publishers:

- Publishers without pagination support.
- Publishers optionally supporting pagination, characterized by a signature containing `paginatedBy` and `pageSize` parameters.

For more information about Combine itself, please have a look at the [official documentation](https://developer.apple.com/documentation/combine). The [Using Combine book](https://heckj.github.io/swiftui-notes) is also a great reference but a steep introduction if you have no prior knowledge of functional and reactive programming.

### Usage

Using publishers is straightforward. Just obtain the publisher for the request you need and write a corresponding pipeline, for example:

```swift
SRGDataProvider.current!.tvLivestreams(for: .SRF)
    // Rest of the pipeline
```

The publisher completes once the results have been delivered or an error has been encountered.

Publishers optionally supporting pagination behave in a similar way when their `paginatedBy` parameter is omitted or `nil`:

```swift
SRGDataProvider.current!.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", pageSize: 50)
    // Rest of the pipeline
```

In this case only a single page of results is returned and the publisher completes. You can use the optional `pageSize` parameter to control how much results must be returned at most.

### Pagination

Setting `paginatedBy` enables pagination support and lets you control when a new page of results must be loaded. Note that a publisher for which pagination has been enabled will only complete once all pages of results have been exhausted.

#### Triggers

Requesting further pages of results from a paginated publisher requires a trigger to be instantiated and stored separately:

```swift
let trigger = Trigger()
```

A trigger defines a local context for communication with a set of publishers. To be able to ask some paginated publisher for a next page of content you must associate it with some `Triggerable`, obtained from the trigger for some integer index:

```swift
SRGDataProvider.current!.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", paginatedBy: trigger.triggerable(activatedBy: 1))
    // Rest of the pipeline
```

The publisher emits the first page of results with the first subscription then waits. When you need the next page of results simply activate the trigger for the corresponding index:

```swift
trigger.activate(for: 1)
```

If a next page of results is available it will be retrieved and delivered to the same pipeline.

#### Trigger indices

In general you should avoid assigning the same index to several publishers, except if you want to use them together as a group. Assigning indices manually is possible, especially if there is some natural ordering involved, but it is better to use a `Hashable` type if possible. 

For example if a list of results is displayed in some `section` of type:

```swift
enum Section: Hashable { /* ... */ }
```

you can use the section itself as index:

```swift
SRGDataProvider.current!.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", paginatedBy: trigger.triggerable(activatedBy: section))
    // Rest of the pipeline
```

and request the next page of results accordingly:

```swift
trigger.activate(for: section)
```

In general you should have a `Trigger` in each local context where you need to control pagination, e.g. in a view model instance. Application-wide triggers must be avoided so that you do not incorrectly assign the same index to unrelated publishers throughout your application.

#### Accumulating results

Subscribers receive results in pages, not as a consolidated list. The reason is that you might want to apply additional processing to each page of results, which would be inefficient if results were accumulated with each new page of results.

Fortunately accumulating results delivered by a pipeline is simple. You should use `scan` to consolidate results as they are made available, for example:

```swift
SRGDataProvider.current!.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", paginatedBy: trigger.triggerable(activatedBy: 2))
    .scan([]) { $0 + $1 }
    // Rest of the pipeline
```

The second example below shows how to search for medias. Search services deliver URN lists, which you can replace with media objects by additionally fetching them, accumulating the results each time a new page of medias has been retrieved:

```swift
SRGDataProvider.current!.medias(for: .RTS, matchingQuery: "jour", pageSize: 20, paginatedBy: trigger.triggerable(activatedBy: 3))
    .map { result in
        return SRGDataProvider.current!.medias(withUrns: result.mediaUrns, pageSize: 20)
    }
    .switchToLatest()
    .scan([]) { $0 + $1 }
    // Rest of the pipeline
```

Since the publisher only completes when all pages of results have been exhausted you usually want to avoid reducers, as they will prevent results from propagating down the pipeline until all upstream publishers have completed, i.e. until all pages of content have been exhausted.

#### Error management

Subscribers for which pagination has been enabled may fail when retrieving the first page of content, propagating the corresponding error downstream.

If the first page of results could be retrieved, though, and if attempting to load an additional page of content fails, for example because the network connection dropped, the operation will silently fail without delivering any additional page to the pipeline. The operation might be reatttempted using the same trigger and identifier as many times as needed.

## Requests and queues

The `SRGDataProviderNetwork` library returns instances of requests from [SRG Network](https://github.com/SRGSSR/srgnetwork-apple/issues), either simple `SRGRequest`, or `SRGFirstPageRequest` for services supporting pagination.

For example, retrieving SRF livestreams is achieved as follows in Swift:

```swift
let request = SRGDataProvider.current!.tvLivestreams(for: .RTS) { (medias, response, error) in
    if let error = error {
        // Deal with the error
        return
    }
    
    // Proceed further, e.g. display the medias
}
request.resume()
```

or in Objective-C:

```objective-c
SRGRequest *request = [SRGDataProvider.currentDataProvider tvLivestreamsForVendor:SRGVendorSRF withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
    if (error) {
        // Deal with the error
        return;
    }
    
    // Proceed further, e.g. display the medias
}];
[request resume];
```

Please carefully read the [SRG Network getting started guide](https://github.com/SRGSSR/srgnetwork-apple/blob/master/docs/GETTING_STARTED.md), which provides extensive information about request management and grouping via queues.

## Service availability

Request availability depends on the business unit. Refer to the provided [service compatibility matrix](SERVICE_AVAILABILITY.md) for reference. This matrix also provides information about page constraints for services supporting pagination.

## App Transport Security (ATS)

In the future, Apple will likely favor HTTPS over HTTP, and require applications to explicitly declare potentially insecure connections. These guidelines are referred to as [App Transport Security (ATS)](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33).

For information about how you should configure your application to access our services, please refer to the dedicated [wiki topic](https://github.com/SRGSSR/srgdataprovider-apple/wiki/App-Transport-Security-(ATS)).
