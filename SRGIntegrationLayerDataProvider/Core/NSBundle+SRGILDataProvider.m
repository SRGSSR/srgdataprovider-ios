//
//  NSBundle+SRGILDataProvider.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 19/10/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "NSBundle+SRGILDataProvider.h"

#import "SRGILDataProvider.h"

@implementation NSBundle (SRGILDataProvider)

+ (instancetype)SRGILDataProviderBundle
{
    static NSBundle *ILDataProviderBundle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSURL *ILDataProviderBundleURL = [[NSBundle bundleForClass:[SRGILDataProvider class]] URLForResource:@"SRGILDataProvider" withExtension:@"bundle"];
        NSAssert(ILDataProviderBundleURL != nil, @"SRGILDataProvider.bundle not found in the main bundle's resources");
        ILDataProviderBundle = [NSBundle bundleWithURL:ILDataProviderBundleURL];
    });
    return ILDataProviderBundle;
}

@end
