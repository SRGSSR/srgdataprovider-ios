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
    NSURL *serviceURL = [NSURL URLWithString:@"http://il-test.srgssr.ch/integrationlayer"];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGBusinessIdentifierSWI];
    [SRGDataProvider setCurrentDataProvider:dataProvider];
    
    return YES;
}

@end
