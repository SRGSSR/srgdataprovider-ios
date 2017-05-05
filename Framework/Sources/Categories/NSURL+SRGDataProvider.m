//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURL+SRGDataProvider.h"

#import <UIKit/UIKit.h>

static SRGDataProviderURLOverridingBlock s_imageURLOverridingBlock = nil;

@implementation NSURL (SRGDataProvider)

+ (void)srg_setImageURLOverridingBlock:(SRGDataProviderURLOverridingBlock)imageURLOverridingBlock
{
    s_imageURLOverridingBlock = imageURLOverridingBlock;
}

- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value uid:(NSString *)uid type:(NSString *)type
{
    if (s_imageURLOverridingBlock && uid) {
        NSURL *overriddenURL = s_imageURLOverridingBlock(uid, type, dimension, value);
        if (overriddenURL) {
            return overriddenURL;
        }
    }
    
    if (self.fileURL || value == 0.f) {
        return self;
    }
    
    // The audio SRF image resizing service (also used for RTR) does not support resizing
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    if ([URLComponents.host isEqualToString:@"www.srfcdn.ch"] || [self.absoluteString containsString:@"srf.ch/static"]) {
        return self;
    }
    
    NSString *dimensionString = (dimension == SRGImageDimensionWidth) ? @"width" : @"height";
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/%@/%@", dimensionString, @(value)];
    URLComponents.path = [URLComponents.path stringByAppendingPathComponent:sizeComponent];
    
    return URLComponents.URL;
}

@end
