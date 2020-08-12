Getting started
===============

This getting started guide discusses all concepts required to use the SRG Data Provider library.

## Data provider instantation and access

At its core, the SRG Data Provider library reduces to a single data provider class, `SRGDataProvider`, which you instantiate for a service URL, for example in Swift:

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

For simplicity, this getting started guide assumes that a shared data provider has been set. If you cannot use the shared instance, store the data providers you instantiated somewhere and provide access to them in some way.

## Combine data publishers

The `SRGDataProviderCombine` library provides publishers which can then be used exactly like a usual `URLSession` publisher, for example:

```swift
var cancellables = Set<AnyCancellable>();

// ...

dataProvider.tvLivestreams(for: .SRF)
	.receive(on: RunLoop.main)
	.map { $0.medias }
	.replaceError(with: [])
	.assign(to: \.medias, on: self)
	.store(in: &cancellables)
```

This example creates a publisher to retrieve SRF event livestreams, assigning them on to a `medias` property on the main thread. The subscription is stored into `cancellables`, a set of `AnyCancellable`, for automatic cancellation if the set is deallocated.

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

## Services

To request data, use the methods available from one of the `SRGDataProvider` _Services_ category. All service methods return an `SRGBaseRequest` instance (or an instance of a subclass thereof), providing you with a common interface to manage requests.

## Service availability

Request availability depends on the business unit. Refer to the provided [service compatibility matrix](SERVICE_AVAILABILITY.md) for reference. This matrix also provides information about page constraints for services supporting pagination.

## App Transport Security (ATS)

In a near future, Apple will favor HTTPS over HTTP, and require applications to explicitly declare potentially insecure connections. These guidelines are referred to as [App Transport Security (ATS)](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33).

For information about how you should configure your application to access our services, please refer to the dedicated [wiki topic](https://github.com/SRGSSR/srgdataprovider-apple/wiki/App-Transport-Security-(ATS)).
