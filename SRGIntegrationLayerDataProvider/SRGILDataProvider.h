//
//  SRGILMediaPlayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <RTSAnalytics/RTSAnalyticsDataSource.h>

@interface SRGILDataProvider : NSObject <RTSMediaPlayerControllerDataSource, RTSAnalyticsDataSource>

+ (NSString *)comScoreVirtualSite:(NSString *)businessUnit;
+ (NSString *)streamSenseVirtualSite:(NSString *)businessUnit;

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit;
- (NSString *)businessUnit;

- (BOOL)isHDURL:(NSURL *)URL forIdentifier:(NSString *)identifier;

@end
