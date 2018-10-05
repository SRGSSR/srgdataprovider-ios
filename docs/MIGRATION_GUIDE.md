Migrating from older versions to version 5
==========================================

Version 5 of the SRG Media Player library is a complete rewrite using the new Integration Layer 2.0 services. Since everything has changed, you should read the [getting started guide](Getting-started.md) guide to learn about how the new version must be used.

The following document therefore only describes the major changes you can expect between version 5 and older versions.

## Carthage

Support for CocoaPods has been removed. Since the framework requires at least iOS 8, using CocoaPods does not make sense anymore. Carthage is both simple and elegant, and will therefore be used in the future for integration into your project. Refer to the [official documentation](https://github.com/Carthage/Carthage) for more information about how to use the tool (don't be afraid, this is very simple).

## Flat data model

The previous data model was, let us be honest, a nightmare to work with. The data received from the server was convoluted, redundant, and not appropriate for mobile clients. The new data format is flat, clean and tight. As a result, model objects are expressive, easy to use, and provide you with directly usable data.

## Request management

Requests are now expressive, easier to build, and much more reliable than before. For convenience, you can now group requests and treat them as a single one.

## Cache

Previously, model objects were cached and returned when readily available. Caching is now entirely the responsibility of `NSURLCache` and follows cache expiration header specifications.

Migrating from version 5 to version 6
==========================================

Version 6 of the library performs a shift towards business unit agnostic data providers. As a result, data provider initialization does not require a business unit parameter anymore. 

URN-based requests stay the same. Requests which previously depended on the business unit now require this information to be supplied when called. Redundant requests (e.g. video, audio or online media lists for some identifiers) have been removed since the URN-based requests can retrieve these medias in a universal way.

