//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILDataProvider.h"
#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <SRGAnalytics/SRGAnalytics.h>

@interface SRGILDataProvider (MediaPlayer) <RTSMediaPlayerControllerDataSource, RTSMediaSegmentsDataSource, RTSAnalyticsMediaPlayerDataSource>

@end
