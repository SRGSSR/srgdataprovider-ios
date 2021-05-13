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

### Publishers without pagination support

You can tell that a publisher does not support pagination if its signature does not contain any `pageSize` or `trigger` parameters. For example there are only a few TV livestreams you always can retrieve in a single operation:

```swift
dataProvider.tvLivestreams(for: .SRF)
```

Simple publishers without pagination support complete when they deliver their results or fail.

### Publishers supporting pagination

Publishers supporting pagination contain a `pageSize` parameter in their signature. They can be seen as a kind of _open socket_, to which you can ask the next page of results when needed. To support this mechanism publishers supporting pagination require a trigger to be instantiated and stored separately:

```swift
let trigger = Trigger()
```

This trigger must be provided when you create the publisher:

```swift
dataProvider.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", trigger: trigger)
```

After a page of content has been delivered to the pipeline the publisher stays idle until you signal it must fetch the next page of results. This is done by pulling the trigger associated with it:

```swift
trigger.pull()
```

Subscribers will receive the next batch of results, not the consolidated list. The reason is that you might want to use a flat map for additional processing of results (e.g. fetching all medias if you are fetching pages of of URNs first). If results were accumulated these additional operations would be accumulated unnecessarily.

Fortunately accumulating results delivered by a pipeline is simple. You should use `scan` as it will deliver consolidated results as they are made available:

```swift
dataProvider.latestMediasForShow(withUrn: "urn:rts:show:tv:532539", trigger: trigger)
    scan([]) { $0 + $1 }
```

The second example below shows how you can simply retrieve URNs for a search criterium, replace them with media objects by fetching them in batch with another request, accumulating the results each time a new page of search results is retrieved:

```swift
dataProvider.medias(for: .RTS, matchingQuery: "jour", pageSize: 20, trigger: trigger)
    .flatMap { result in
        return SRGDataProvider.current!.medias(withUrns: result.mediaUrns, pageSize: 20)
    }
    .scan([]) { $0 + $1 }
```

Note that the publisher only completes when all pages of results have been exhausted. This is why you should probably avoid reducers, as they will prevent results from propagating down the pipeline until all pages of results have been exhausted.

For more information about Combine itself, please have a look at the [official documentation](https://developer.apple.com/documentation/combine). The [Using Combine book](https://heckj.github.io/swiftui-notes) is also a great reference but not a mild introduction if you need to learn functional and reactive programming first.

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
