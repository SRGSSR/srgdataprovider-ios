Getting started
===============

This getting started guide discusses all concepts required to use the SRG Data Provider library.

## Data provider instantation and access

At its core, the SRG Data Provider library reduces to a single data provider class, `SRGDataProvider`, which you instantiate for a service URL, for example:

```objective-c
SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
```

A set of constants for common service URLs (production, staging and test) is provided. You can have several data providers in an application, though most applications should require only one. To make it easier to access the main data provider of an application, the `SRGDataProvider` class provides a class property to set and retrive it as shared instance:

```objective-c
SRGDataProvider.currentDataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
```

For simplicity, this getting started guide assumes that a shared data provider has been set. If you cannot use the shared instance, store the data providers you instantiated somewhere and provide access to them in some way.

## Requests and queues

The SRG Data Provider library returns instances of requests from [SRG Network](https://github.com/SRGSSR/srgnetwork-ios/issues), either simple `SRGRequest`, or `SRGFirstPageRequest` for services supporting pagination.

Please carefully read the [SRG Network getting started guide](https://github.com/SRGSSR/srgnetwork-ios/blob/master/docs/GETTING_STARTED.md), which provides extensive information about request management and grouping via queues.

## Services

To request data, use the methods available from one of the `SRGDataProvider` _Services_ category. All service methods return an `SRGBaseRequest` instance (or an instance of a subclass thereof), providing you with a common interface to manage requests.

For example, to get the list of SRF TV livestream list, simply call:

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

Note that the completion block of a cancelled request will not be called.

## Service availability

Request availability depends on the business unit. Refer to the provided [service compatibility matrix](SERVICE_AVAILABILITY.md) for reference. This matrix also provides information about page constraints for services supporting pagination.

## App Transport Security (ATS)

In a near future, Apple will favor HTTPS over HTTP, and require applications to explicitly declare potentially insecure connections. These guidelines are referred to as [App Transport Security (ATS)](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33).

For information about how you should configure your application to access our services, please refer to the dedicated [wiki topic](https://github.com/SRGSSR/srgdataprovider-ios/wiki/App-Transport-Security-(ATS)).
