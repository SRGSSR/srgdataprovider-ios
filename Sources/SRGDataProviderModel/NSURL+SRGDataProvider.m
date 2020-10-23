//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURL+SRGDataProvider.h"

@implementation NSURL (SRGDataProvider)

- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    if (self.fileURL || value == 0.f) {
        return self;
    }
    
    NSString *dimensionString = (dimension == SRGImageDimensionWidth) ? @"width" : @"height";
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/%@/%@", dimensionString, @(value)];
    
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    URLComponents.path = [URLComponents.path stringByAppendingPathComponent:sizeComponent];
    
    return URLComponents.URL;
}

@end
