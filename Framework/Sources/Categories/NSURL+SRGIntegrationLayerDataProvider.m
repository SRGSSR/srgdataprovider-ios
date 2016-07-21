//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURL+SRGIntegrationLayerDataProvider.h"

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SRGImageDimension) {
    SRGImageDimensionWidth,
    SRGImageDimensionHeight
};

@implementation NSURL (SRGUtils)

- (NSURL *)srg_URLForWidth:(CGFloat)width
{
    return [self srg_URLForDimension:SRGImageDimensionWidth withValue:width];
}

- (NSURL *)srg_URLForHeight:(CGFloat)height
{
    return [self srg_URLForDimension:SRGImageDimensionHeight withValue:height];
}

- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
    if (self.fileURL || value == 0.f) {
        return self;
    }
    
    // The audio SRG image resizing service (also used for RTR) does not support resizing
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:nil];
    if ([URLComponents.host isEqualToString:@"www.srfcdn.ch"]) {
        return self;
    }
    
    NSString *dimensionString = (dimension == SRGImageDimensionWidth) ? @"width" : @"height";
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/%@/%@", dimensionString, @(value * [UIScreen mainScreen].scale)];
    URLComponents.path = [URLComponents.path stringByAppendingPathComponent:sizeComponent];
    
    return URLComponents.URL;
}

@end
