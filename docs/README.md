[![SRG Data Provider logo](README-images/logo.png)](https://github.com/SRGSSR/srgdataprovider-apple)

[![GitHub releases](https://img.shields.io/github/v/release/SRGSSR/srgdataprovider-apple)](https://github.com/SRGSSR/srgdataprovider-apple/releases) [![platform](https://img.shields.io/badge/platfom-ios%20%7C%20tvos%20%7C%20watchos-blue)](https://github.com/SRGSSR/srgdataprovider-apple) [![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager) [![Build Status](https://travis-ci.org/SRGSSR/srgdataprovider-apple.svg?branch=master)](https://travis-ci.org/SRGSSR/srgdataprovider-apple/branches) [![GitHub license](https://img.shields.io/github/license/SRGSSR/srgdataprovider-apple)](https://github.com/SRGSSR/srgdataprovider-apple/blob/master/LICENSE)

## About

The SRG Data Provider library provides a simple way to retrieve metadata for all SRG SSRG business units in a common format.

The library provides:

* Requests to get the usual metadata associated with SRG SSR productions.
* A flat object model to easily access the data relevant to front-end users.
* [Combine](https://developer.apple.com/documentation/combine) data publishers available for iOS 13+, tvOS 13+ and watchOS 6+.
* An alternative way to perform requests for applications which cannot use Combine, based on [SRG Network](https://github.com/SRGSSR/srgnetwork-apple).

## Compatibility

The library is suitable for applications running on iOS 9, tvOS 12, watchOS 5 and above. The project is meant to be compiled with the latest Xcode version.

## Contributing

If you want to contribute to the project, have a look at our [contributing guide](CONTRIBUTING.md).

## Integration

The library must be integrated using [Swift Package Manager](https://swift.org/package-manager) directly [within Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app). You can also declare the library as a dependency of another one directly in the associated `Package.swift` manifest.

## Usage

When you want to use classes or functions provided by the library in your code, you must import it from your source files first. Objective-C applications can only use the SRG Network based API:

```objective-c
@import SRGDataProviderNetwork;
```

Projects in Swift can either use the Combine API:

```swift
import SRGDataProviderCombine
```

or SRG Network based requests and queues:

```swift
import SRGDataProviderNetwork
```

Both approaches can be used within the same project, though you should preferably choose one approach and stick with it for consistency. 

For Swift projects supporting iOS 13+, tvOS 13+ or watchOS 6+, the use of Combine is strongly recommended, as it allows SRG SSR data retrieval tasks to be freely and reliably mixed with other asynchronous work (e.g. local data retrieval from a Core Data stack).

### Working with the library

To learn about how the library can be used, have a look at the [getting started guide](GETTING_STARTED.md).

### Logging

The library internally uses the [SRG Logger](https://github.com/SRGSSR/srglogger-apple) library for logging, within the `ch.srgssr.dataprovider` subsystem. This logger either automatically integrates with your own logger, or can be easily integrated with it. Refer to the SRG Logger documentation for more information.

## Supported requests

The supported requests vary depending on the business unit. A [compatibility matrix](SERVICE_AVAILABILITY.md) is provided for reference.

## Examples

To see examples of use, have a look a the unit test suite bundled with the project.

## License

See the [LICENSE](../LICENSE) file for more information.
