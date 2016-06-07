![SRG IL Data Provider logo](README-images/logo.png)

## About

The SRG Integration Layer (IL) Data Provider library for iOS provides a simple way to communicate with the common service shared by SRG business units.

The library can optionally be combined with the media player and / or analytics libraries, so that token retrieval for media playback as well as comScore labels are automatically retrieved in a standard way.

## Compatibility

The library is suitable for applications running on iOS 7 and above.

## Installation

The library can be added to a project through [CocoaPods](http://cocoapods.org/) version 1.0 or above. Create a `Podfile` with the following contents:

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

* To add optional support for the [SRG Media Player library](https://bitbucket.org/rtsmb/srgmediaplayer-ios), add the corresponding subspec (it is preferable not to provide an explicit version number for subspecs):

```
#!ruby
    pod 'SRGIntegrationLayerDataProvider/MediaPlayer'
```

* To add optional support for the [SRG Analytics library](https://bitbucket.org/rtsmb/srganalytics-ios) when playing media, add the corresponding subspec (it is preferable not to provide an explicit version number for subspecs):

```
#!ruby
    pod 'SRGIntegrationLayerDataProvider/MediaPlayer/Analytics'
```

Then run `pod install` to update the dependencies.

For more information about CocoaPods and the `Podfile`, please refer to the [official documentation](http://guides.cocoapods.org/).


## Quick Start

Every request to the IL is made through a data provider, instantiated with a business uit identifier as follows:

```
#!objective-c
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:<business unit string>];
```

The default URL is `http://il.srgssr.ch` and you need to check which business unit is supported. Currently, the `sfr`, `rts`, `rsi`, `rtr` and `swi` business unit identifiers are supported.

Usually, you only need a single data provider instance for your application. This instance must be kept somewhere for reuse. A convenient approach is to have a singleton instance returned from a function, as follows:

```
#!objective-c
SRGILDataProvider *SRFDataProvider(void)
{
	static SRGILDataProvider *dataProvider;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
    });
    return dataProvider;
}
```

You can then access this provider by simply calling `SRFDataProvider()`.

To fetch a list of items, create an URL component object with the desired fetch list index (the type of request) and, optionally, an identifier:

```
#!objective-c
    SRGILURLComponents *components = [SRGILURLComponents componentsForFetchListIndex:<fetch list index>
                                                                      withIdentifier:<an optional identifier relevant for that fetch index>
                                                                               error:<an optional error>];
```

Then perform the request by providing those components to the data provider:

```
#!objective-c
[dataProvider fetchObjectsListWithURLComponents:components
                                      organised:<SRGILModelDataOrganisationTypeFlat or SRGILModelDataOrganisationTypeAlphabetical>
                                     onProgress:<an optional progress block>
                                   onCompletion:<a completion block>];
```

The completion block is called with an array of objects, usually `SRGILAudio`, `SRGILVideo` or `SRGILShow` instances.

When you have a media to play, request its complete metadata using its URN (unique identifier):

```
#!objective-c
SRGILURN *mediaURN = [SRGILURN URNWithString:<a media URN string>];
[dataProvider fetchMediaWithURN:mediaURN
                completionBlock:<a completion block>];
```

The completion block is called with an `SRGILAudio`, `SRGILVideo` or a `SRGILShow` object, from which you can extract the information you need.

## Media player integration

Playback of a media requires an authorization token. If you add the `SRGIntegrationLayerDataProvider/MediaPlayer` subspec to your `Podfile`, the token is transparently retrieved for you when playing a media using its identifier, provided you use the data provider above as data source of the media player:

* If you use `RTSMediaPlayerController`, assign your data provider to its `dataSource` property. Alternatively, you can provide the data source at creation time:

```
#!objective-c
RTSMediaPlayerController *mediaPlayerController = [[RTSMediaPlayerController alloc] initWithContentIdentifier:<a media URN string> dataSource:dataProvider]
```

* If you use `RTSMediaPlayerViewController`, provide the data source at creation time:

```
#!objective-c
RTSMediaPlayerViewController *mediaPlayerViewController = [[RTSMediaPlayerViewController alloc] initWithContentIdentifier:<a media URN string> dataSource:dataProvider]
```

### Analytics integration

If you want to send comScore and StreamSense analytics labels when playing a media with either `RTSMediaPlayerController` or `RTSMediaPlayerViewController`, add the `SRGIntegrationLayerDataProvider/MediaPlayer/Analytics` subspec to your `Podfile`. 

You must start tracking for your data provider, as described in the [SRG Analytics library](https://bitbucket.org/rtsmb/srganalytics-ios) readme file:

```
#!objective-c
    [[RTSAnalyticsTracker sharedTracker] startTrackingForBusinessUnit:<business unit>
                                                      mediaDataSource:dataProvider];
```

Be sure that media players have been associated with a data source as described above.

## License

See the [LICENSE](LICENSE) file for more information.
