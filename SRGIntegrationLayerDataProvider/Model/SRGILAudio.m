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
    // HLS DVR
    NSURL *URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLSDVR withQuality:SRGILPlaylistURLQualityHD];
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLSDVR withQuality:SRGILPlaylistURLQualityHQ];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLSDVR withQuality:SRGILPlaylistURLQualityMQ];
    }
    
    // HLS
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityHD];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityHQ];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityMQ];
    }
    
    // HTTPS
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTPS withQuality:SRGILPlaylistURLQualityHD];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTPS withQuality:SRGILPlaylistURLQualityHQ];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTPS withQuality:SRGILPlaylistURLQualityMQ];
    }
    
    // HTTP
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTP withQuality:SRGILPlaylistURLQualityHD];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTP withQuality:SRGILPlaylistURLQualityHQ];
    }
    
    if (!URL) {
        URL = [self contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHTTP withQuality:SRGILPlaylistURLQualityMQ];
    }
    
    return URL;
}

@end
