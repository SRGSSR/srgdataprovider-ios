//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSBundle+SRGDataProvider.h"

#import "SRGDataProvider.h"

@implementation NSBundle (SRGDataProvider)

+ (NSBundle *)srg_dataProviderBundle
{
    static dispatch_once_t s_onceToken;
    static NSBundle *s_bundle;
    dispatch_once(&s_onceToken, ^{
        NSString *bundlePath = [[NSBundle bundleForClass:SRGDataProvider.class].bundlePath stringByAppendingPathComponent:@"SRGDataProvider.bundle"];
        s_bundle = [NSBundle bundleWithPath:bundlePath];
        NSAssert(s_bundle, @"Please add SRGDataProvider.bundle to your project resources");
    });
    return s_bundle;
}

@end
