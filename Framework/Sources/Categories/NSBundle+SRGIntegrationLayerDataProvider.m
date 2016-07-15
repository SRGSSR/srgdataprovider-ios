//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSBundle+SRGIntegrationLayerDataProvider.h"

#import "SRGDataProvider.h"

@implementation NSBundle (SRGIntegrationLayerDataProvider)

+ (NSBundle *)srg_integrationLayerDataProviderBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *bundle;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleForClass:[SRGDataProvider class]];
    });
    return bundle;
}

@end
