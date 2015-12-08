//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGAnalytics/SRGAnalytics.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    self.dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    
    [[RTSAnalyticsTracker sharedTracker] startTrackingForBusinessUnit:SSRBusinessUnitRTS
                                                      mediaDataSource:self.dataProvider
                                                          inDebugMode:YES];
        
    return YES;
}

@end
