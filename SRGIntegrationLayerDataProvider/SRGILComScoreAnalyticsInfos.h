//
//  SRGComscoreAnalyticsDataSource.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 15/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSAnalytics/RTSAnalyticsDataSource.h>
#import "SRGILAnalyticsInfosProtocol.h"

@interface SRGILComScoreAnalyticsInfos : NSObject <SRGILAnalyticsInfos>

+ (NSDictionary *)globalLabelsForAppEnteringForeground;

- (RTSAnalyticsMediaMode)mediaMode;
- (NSDictionary *)statusLabels;

@end
