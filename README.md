![SRG IL Data Provider logo](README-images/logo.png)

## About

The SRG Integration Layer (IL) Data Provider library for iOS provides a simple way to communicate with the common service shared by SRG business units.
It has been developed along with the SRGMediaPlayer library. However, this dependency is optional, and must be activated as explained below,
if you want to use this provider with the media player.

## Quick Start

Create a property where you need it, and instanciate a IL Data provider like this:

```
#!objective-c
    self.ILDataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:<business unit string>];
```
The default URL is `http://il.srgssr.ch` and you need to check which business unit is supported. Today, we have `sfr`, `rts`, `rsi`, `rtr`and `swi`.

To fetch a list of items, create an URL component object with the desired playlist:

```
#!objective-c
	[SRGILURLComponents componentsForFetchListIndex:<fetch list index>
                                     withIdentifier:<an optional identifier relevant for that fetch index>
                                              error:<an optional error>];
```

Then, fetch the list like this:

```
#!objective-c
    [self.ILDataProvider fetchObjectsListWithURLComponents:<fetch SRGILURLComponents object>
                                                 organised:<SRGILModelDataOrganisationTypeFlat or SRGILModelDataOrganisationTypeAlphabetical>
                                                onProgress:<an optional progress block>
                                              onCompletion:<a completion block>];
```

When you have a media to play, request its complete metadata with its URN (unique identifier):

```
#!objective-c
	SRGILURN *mediaURN = [SRGILURN URNWithString:<a media URN string>];
    [self.ILDataProvider fetchMediaWithURN:mediaURN
                           completionBlock:<a completion block>];
```

We get an `SRGILAudio`, `SRGILVideo` or a `SRGILShow`object in response.

## IL Data Provider + MediaPlayer

If you want to play a media content from the default SRG data provider, you need to deal with an authorisation token.
The library can give the URL with the token, like this:

```
#!objective-c
    [self.ILDataProvider mediaPlayerController:<an RTS media player controller object)
                           contentURLForIdentifier:<a media identifier string>
                           completionHandler:<a completion block>];
```
It should be used in the `RTSMediaPlayerControllerDataSource` protocol method `mediaPlayerController:contentURLForIdentifier:completionHandler:`. With a CocoaPods installation, don't forget to add the pod subspec.

## Compatibility

The library is suitable for applications running on iOS 7 and above.

## Installation

The library can be added to a project through [CocoaPods](http://cocoapods.org/). Create a `Podfile` with the following contents:

* The SRG specification repository:
    
```
#!ruby
    source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'
```
    
* The `SRGIntegrationLayerDataProvider` dependency:

```
#!ruby
    pod 'SRGIntegrationLayerDataProvider', '<version>'
```

* To add optional support for the [SRG Media Player library](https://bitbucket.org/rtsmb/srgmediaplayer-ios):

```
#!ruby
    pod 'SRGIntegrationLayerDataProvider/MediaPlayer'
```

It is preferable not to provide a version number for the `SRGMediaPlayer` subspec.

Then run `pod install` to update the dependencies.

For more information about CocoaPods and the `Podfile`, please refer to the [official documentation](http://guides.cocoapods.org/).

## License

See the [LICENSE](LICENSE) file for more information.
