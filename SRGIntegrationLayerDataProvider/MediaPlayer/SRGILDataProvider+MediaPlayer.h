//
//  SRGILDataProvider+MediaPlayer.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 18/05/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider.h"
#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <RTSAnalytics/RTSAnalytics.h>

@interface SRGILDataProvider (MediaPlayer) <RTSMediaPlayerControllerDataSource, RTSAnalyticsMediaPlayerDataSource>

@end
