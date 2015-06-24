//
//  SRGILDataProvider+MediaPlayer.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 18/05/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider.h"
#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <SRGAnalytics/SRGAnalytics.h>

@interface SRGILDataProvider (MediaPlayer) <RTSMediaPlayerControllerDataSource, RTSMediaSegmentsDataSource, RTSAnalyticsMediaPlayerDataSource>

@end
