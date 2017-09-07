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

- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value uid:(NSString *)uid type:(SRGImageType)type
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
    if ([URLComponents.host isEqualToString:@"www.srfcdn.ch"] ||
        ([URLComponents.host isEqualToString:@"www.srf.ch"] && [URLComponents.path containsString:@"/static/"])) {
        return self;
    }
    
    NSString *dimensionString = (dimension == SRGImageDimensionWidth) ? @"width" : @"height";
    NSString *sizeComponent = [NSString stringWithFormat:@"scale/%@/%@", dimensionString, @(value)];
    URLComponents.path = [URLComponents.path stringByAppendingPathComponent:sizeComponent];
    
    // For apigee URL, don't forget double / in path URL, removed by NSURLComponents
    // It seems that our apigee API allows to have only :/ in path but have the same path is prefered
    if ([self.path containsString:@"://"] && ! [URLComponents.path containsString:@"://"]) {
        URLComponents.path = [URLComponents.path stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
    }
    
    return URLComponents.URL;
}

@end
