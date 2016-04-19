//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILDataProvider.h"

#import <SRGMediaPlayer/SRGMediaPlayer.h>

/**
 *  These categories of the IL Data provider providing a complete impementation of all what is required by the
 *  media player for running playback and supply analytics infos.
 */
@interface SRGILDataProvider (MediaPlayer) <RTSMediaPlayerControllerDataSource, RTSMediaSegmentsDataSource>

@end

#if __has_include("SRGILDataProviderMediaPlayerDataSource.h")

#import <SRGAnalytics/SRGAnalytics.h>

@interface SRGILDataProvider (MediaPlayer_Analytics) <RTSAnalyticsMediaPlayerDataSource>

@end

#endif
