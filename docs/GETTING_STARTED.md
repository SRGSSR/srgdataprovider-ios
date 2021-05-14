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
When subscribing to an SRG Data Provider publisher the corresponding request is performed and results are delivered to the pipeline.

SRG Data Provider offers two kinds of publishers:

- Simple publishers without pagination support. These publishers complete once they delivered their results.
- Publishers with pagination support, whose signature contain `pageSize` and `triggerId` parameters. These publishers only complete once all pages of content they can deliver have been exhausted.

SRG Data Provider publishers, whether they support pagination or not, can be seen as some kinds of _data sockets_. You subscribe to them, receive results, and ask them when more data is desired.

For more information about Combine itself, please have a look at the [official documentation](https://developer.apple.com/documentation/combine). The [Using Combine book](https://heckj.github.io/swiftui-notes) is also a great reference but a steep introduction if you have no prior knowledge of functional and reactive programming.

### Simple publishers

Publishers without pagination support are easy to use. Just obtain the publisher for the request you need and write a corresponding pipeline, for example:

```swift
dataProvider.tvLivestreams(for: .SRF)
    // Rest of the pipeline
```

### Publishers supporting pagination

Publishers supporting pagination are used like simple publishers, with the exception that you need to request further pages of results when needed.

#### Triggers

Requesting further results requires a trigger to be instantiated and stored separately:

```swift
let trigger = Trigger()
```

A trigger is a local communication channel with a set of publishers. To setup a communication channel with a publisher you must assign it a unique `Int` identifier at construction time. This identifier is obtained from the `trigger` instance with the help of an arbitrary associated `Int` index, e.g. 1234:

```swift
dataProvider.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", triggerId: trigger.id(1234))
    // Rest of the pipeline
```

The publisher emits the first page of results with the first subscription, then sits idle. When you need the next page of results simply request it using the same trigger and index:

```swift
trigger.signal(1234)
```

If a next page of results is available it will be retrieved and delivered to the pipeline.

#### Trigger identifiers

In general you should avoid assigning the same identifier to several publishers, except if you want to trigger them as a group. Assigning indices manually is possible (especially if there is some logical ordering involved), but if requests are related to a `Hashable` type there is a better way. For example, if each request is associated with a section:

```swift
enum Section: Hashable { /* ... */ }
```

you can simply generate the identifier for one of its instances `section` as follows:

```swift
dataProvider.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", triggerId: trigger.id(section))
    // Rest of the pipeline
```

In general you should have a `Trigger` in each local context where you need to control pagination, e.g. in a view model instance. Application-wide triggers must be avoided for obvious reasons. When you have a trigger, create identifiers from `Hashable` types if possible to automatically avoid collisions, otherwise carefully assign indices as you want. 

#### Accumulating results

Subscribers receive results in pages, not as a consolidated list. The reason is that you might want to use a flat map for additional processing of each page of results. If results were accumulated with each update these additional operations would pile up inefficiently.

Fortunately accumulating results delivered by a pipeline is simple. You should use `scan` to consolidate results as they are made available, for example:

```swift
dataProvider.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", triggerId: triggerId)
    .scan([]) { $0 + $1 }
    // Rest of the pipeline
```

The second example below shows how you can search medias URNs. Search services deliver URN lists, which you can replace with media objects by additionally fetching them, accumulating the results each time a new page of medias has been retrieved:

```swift
dataProvider.medias(for: .RTS, matchingQuery: "jour", pageSize: 20, triggerId: triggerId)
    .flatMap { result in
        return SRGDataProvider.current!.medias(withUrns: result.mediaUrns, pageSize: 20)
    }
    .scan([]) { $0 + $1 }
    // Rest of the pipeline
```

Since the publisher only completes when all pages of results have been exhausted you usually want to avoid reducers, as they will prevent results from propagating down the pipeline until all upstream publishers have completed, i.e. until all pages of content have been exhausted.

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
