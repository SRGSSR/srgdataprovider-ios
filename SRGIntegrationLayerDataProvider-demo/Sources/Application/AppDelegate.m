//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "AppDelegate.h"

@import SRGIntegrationLayerDataProvider;

@implementation AppDelegate

#pragma mark UIApplicationDelegate protocol

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *serviceURL = [NSURL URLWithString:@"http://il.srgssr.ch"];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:@"srf"];
    [SRGDataProvider setCurrentDataProvider:dataProvider];
    
    SRGDataProvider *currentDataProvider = [SRGDataProvider currentDataProvider];
    NSLog(@"Currently: %@ - %@", currentDataProvider.serviceURL, currentDataProvider.businessUnitIdentifier);
    return YES;
}

@end
