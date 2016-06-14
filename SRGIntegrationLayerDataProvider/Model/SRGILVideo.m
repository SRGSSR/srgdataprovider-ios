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

- (NSURL *)defaultContentURL
{
    NSURL *contentURL = nil;
    
    BOOL takeHDVideo = [[NSUserDefaults standardUserDefaults] boolForKey:SRGILVideoUseHighQualityOverCellularNetworkKey];
    BOOL usingTrueWIFINetwork = [SRGILRequestsManager isUsingWIFI] && ![SRGILRequestsManager isUsingSwisscomWIFI];
    
    // HLS DVR first, HLS otherwise
    NSURL *qualityHDURL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLSDVR withQuality:SRGILPlaylistURLQualityHD];
    if (!qualityHDURL) {
        qualityHDURL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityHD];
    }
    NSURL *qualitySDURL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLSDVR withQuality:SRGILPlaylistURLQualitySD];
    if (!qualitySDURL) {
        qualitySDURL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualitySD];
    }
    
    if (usingTrueWIFINetwork || takeHDVideo) {
        // We are on True WIFI (non-Swisscom) or the HD quality switch is ON. We play HD (HLS) if we have it. SD otherwise.
        contentURL = qualityHDURL ?: qualitySDURL;
    }
    else {
        // We are not on WIFI and switch is OFF. YES, business decision: we play HD as backup if we don't have SD.
        contentURL = qualitySDURL ?: qualityHDURL;
    }
    
    return contentURL;
}

@end
