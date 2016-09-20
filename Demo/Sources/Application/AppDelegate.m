//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "AppDelegate.h"

@import SRGDataProvider;

@implementation AppDelegate

#pragma mark UIApplicationDelegate protocol

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *serviceURL = [NSURL URLWithString:@"http://il-test.srgssr.ch/integrationlayer"];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSWI];
    [SRGDataProvider setCurrentDataProvider:dataProvider];
    
    return YES;
}

@end
