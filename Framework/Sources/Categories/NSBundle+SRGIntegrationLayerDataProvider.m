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
    static dispatch_once_t s_onceToken;
    static NSBundle *s_bundle;
    dispatch_once(&s_onceToken, ^{
        s_bundle = [NSBundle bundleForClass:[SRGDataProvider class]];
    });
    return s_bundle;
}

@end
