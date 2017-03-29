//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURL+SRGDataProvider.h"

#import <UIKit/UIKit.h>

@implementation NSURL (SRGUtils)

- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
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
