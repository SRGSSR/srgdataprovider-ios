//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILVideo.h"
#import "SRGILRequestsManager.h"

@implementation SRGILVideo

- (SRGILMediaType)type
{
    return SRGILMediaTypeVideo;
}

- (NSURL *)contentURL
{
    NSURL *contentURL = nil;
    
    BOOL takeHDVideo = [[NSUserDefaults standardUserDefaults] boolForKey:SRGILVideoUseHighQualityOverCellularNetworkKey];
    BOOL usingTrueWIFINetwork = [SRGILRequestsManager isUsingWIFI] && ![SRGILRequestsManager isUsingSwisscomWIFI];
    
    if (usingTrueWIFINetwork || takeHDVideo) {
        // We are on True WIFI (non-Swisscom) or the HD quality switch is ON.
        contentURL = (self.HDHLSURL) ? [self.HDHLSURL copy] : [self.SDHLSURL copy];
    }
    else {
        // We are not on WIFI and switch is OFF. YES, business decision: we play HD as backup if we don't have SD.
        contentURL = (self.SDHLSURL) ? [self.SDHLSURL copy] : [self.HDHLSURL copy];
    }
    
    return contentURL;
}

@end
