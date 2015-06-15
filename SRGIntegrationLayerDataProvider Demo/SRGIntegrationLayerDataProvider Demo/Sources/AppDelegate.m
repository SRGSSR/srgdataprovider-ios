//
//  AppDelegate.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <RTSAnalytics/RTSAnalytics.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    self.dataSource = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];

    [[RTSAnalyticsTracker sharedTracker] setComscoreVSite:@"rts-app-test-v"];
    [[RTSAnalyticsTracker sharedTracker] setNetmetrixAppId:@"test"];
    [[RTSAnalyticsTracker sharedTracker] setProduction:NO];

    [[RTSAnalyticsTracker sharedTracker] startTrackingForBusinessUnit:SSRBusinessUnitRTS
                                                        launchOptions:launchOptions
                                                      mediaDataSource:self.dataSource];
    
    [[RTSAnalyticsTracker sharedTracker] setLogEnabled:YES];
    
    return YES;
}

@end
