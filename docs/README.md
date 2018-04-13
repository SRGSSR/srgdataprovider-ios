![SRG Data Provider logo](README-images/logo.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

## About

The SRG Data Provider library for iOS provides a simple way to retrieve metadata for all SRG SSRG business units in a common format.

The library provides:

* Requests to get the usual metadata associated with SRG SSR productions.
* A flat object model to easily access the data relevant to front-end users.
* A convenient way to perform requests, either in parallel or in cascade.

## Compatibility

The library is suitable for applications running on iOS 9 and above. The project is meant to be opened with the latest Xcode version (currently Xcode 9).

## Installation

The library can be added to a project using [Carthage](https://github.com/Carthage/Carthage) by specifying the following dependency in your `Cartfile`:
    
```
github "SRGSSR/srgdataprovider-ios"
```

Then run `carthage update --platform iOS` to update the dependencies. You will need to manually add the following `.framework`s generated in the `Carthage/Build/iOS` folder to your project:

* `libextobjc`: A utility framework
* `MAKVONotificationCenter`: A safe KVO framework.
* `Mantle`: The framework used to parse the data.
* `SRGDataProvider`: The main data provider framework.
* `SRGLogger`: The framework used for internal logging.

For more information about Carthage and its use, refer to the [official documentation](https://github.com/Carthage/Carthage).

## Usage

When you want to use classes or functions provided by the library in your code, you must import it from your source files first.

### Usage from Objective-C source files

Import the global header file using:

```objective-c
#import <SRGDataProvider/SRGDataProvider.h>
```

or directly import the module itself:

```objective-c
@import SRGDataProvider;
```

### Usage from Swift source files

Import the module where needed:

```swift
import SRGDataProvider
```

### Working with the library

To learn about how the library can be used, have a look at the [getting started guide](Getting-started.md).

### Logging

The library internally uses the [SRG Logger](https://github.com/SRGSSR/srglogger-ios) library for logging, within the `ch.srgssr.dataprovider` subsystem. This logger either automatically integrates with your own logger, or can be easily integrated with it. Refer to the SRG Logger documentation for more information.

## Supported requests

The supported requests vary depending on the business unit. A [compatibility matrix](Service-availability.md) is provided for reference.

## Examples

To see examples of use, have a look a the unit test suite bundled with the project.

## Migration from versions previous versions

For information about changes introduced with major versions of the library, please read the [migration guide](Migration-guide.md).

## License

See the [LICENSE](../LICENSE) file for more information.
