![SRG IL Data Provider logo](README-images/logo.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![Platform](https://img.shields.io/cocoapods/p/CoconutKit.svg) ![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

## About

The SRG Data Provider library for iOS provides a simple way to retrieve metadata for all SRG SSRG business units in a common format.

The library provides:

* Requests to get the usual metadata associated with SRG SSR productions
* A flat object model to easily access the data relevant to front-end users
* A convenient way to perform requests, either in parallel or in cascade.

## Compatibility

The library is suitable for applications running on iOS 8 and above. The project is meant to be opened with the latest Xcode version (currently Xcode 8).

## Installation

The library can be added to a project using [Carthage](https://github.com/Carthage/Carthage)  by adding the following dependency to your `Cartfile`:
    
```
github "SRGSSR/srgdataprovider-ios"
```

Then run `carthage update` to update the dependencies. You will need to manually add the following `.framework`s generated in the `Carthage/Build/iOS` folder to your projet:

* `SRGDataProvider.framework`: The main data provider framework
* `Mantle.framework`: The framework which is used to parse the data

For more information about Carthage and its use, refer to the [official documentation](https://github.com/Carthage/Carthage).

## Usage

When you want to classes or functions provided by the library in your code, you must import it from your source files first.

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

To learn about how the library can be used, have a look at the [getting started guide](Documentation/Getting-started.md).

## Demo project

To test what the library is capable of, try running the associated demo by opening the workspace and building the associated scheme.

## Migration from versions previous versions

For information about changes introduced with version 5 of the library, please read the [migration guide](Documentation/Migration-guide.md).

## License

See the [LICENSE](LICENSE) file for more information.
