//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILAudio.h"

@implementation SRGILAudio

- (SRGILMediaType)type
{
    return SRGILMediaTypeAudio;
}

- (NSURL *)defaultContentURL
{
    NSURL *URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLSDVR withQuality:SRGILPlaylistURLQualityMQ];
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityMQ];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTP withQuality:SRGILPlaylistURLQualityMQ];
    }
    
    // Up to that point, that is the logic used for SRF (that we want to keep). But RTS audios are provided in HQ buckets...
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityHQ];
    }
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTP withQuality:SRGILPlaylistURLQualityHQ];
    }
    
    return URL;
}

@end
