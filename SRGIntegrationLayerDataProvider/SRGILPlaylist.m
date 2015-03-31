//
//  SRGPlaylist.m
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 20/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILPlaylist.h"

SRGPlaylistProtocol SRGPlayListProtocolForString(NSString *protocol)
{
    if (protocol) {
        if ([@"HTTP-HDS" isEqualToString:protocol]) {
            return SRGPlaylistProtocolHDS;
        }
        if ([@"HTTP-HLS" isEqualToString:protocol]) {
            return SRGPlaylistProtocolHLS;
        }
        if ([@"HTTP" isEqualToString:protocol]) {
            return SRGPlaylistProtocolHTTP;
        }
        if ([@"RTMP" isEqualToString:protocol]) {
            return SRGPlaylistProtocolRTMP;
        }
    }
    return SRGPlaylistProtocolUnknown;
}

SRGPlaylistURLQuality SRGPlaylistURLQualityForString(NSString *quality)
{
    if (quality) {
        if ([@"SD" isEqualToString:quality]) {
            return SRGPlaylistURLQualitySD;
        }
        if ([@"HD" isEqualToString:quality]) {
            return SRGPlaylistURLQualityHD;
        }
        if ([@"SQ" isEqualToString:quality]) {
            return SRGPlaylistURLQualitySQ;
        }
        if ([@"LQ" isEqualToString:quality]) {
            return SRGPlaylistURLQualityLQ;
        }
        if ([@"MQ" isEqualToString:quality]) {
            return SRGPlaylistURLQualityMQ;
        }
        if ([@"HQ" isEqualToString:quality]) {
            return SRGPlaylistURLQualityHQ;
        }
    }
    return SRGPlaylistURLQualityUnknown;
}

SRGPlaylistSegmentation SRGPlaylistSegmentationForString(NSString *segmentation)
{
    if (segmentation) {
        if ([@"PHYSICAL" isEqualToString:segmentation]) {
            return SRGPlaylistSegmentationPhysical;
        }
        if ([@"LOGICAL" isEqualToString:segmentation]) {
            return SRGPlaylistSegmentationLogical;
        }
    }
    return SRGPlaylistSegmentationUnknown;
}

@interface SRGILPlaylist()

@property(nonatomic) SRGPlaylistProtocol protocol;
@property(nonatomic) SRGPlaylistSegmentation segmentation;
@property(nonatomic) SRGPlaylistURLQuality quality;
@property(nonatomic) NSDictionary *URLs;

@end


@implementation SRGILPlaylist

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _protocol = SRGPlayListProtocolForString([dictionary objectForKey:@"@protocol"]);
        _segmentation = SRGPlaylistSegmentationForString([dictionary objectForKey:@"@segmentation"]);
        
        NSArray *rawURLs = [dictionary objectForKey:@"url"];
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        for (NSDictionary *rawURLDict in rawURLs) {
            NSNumber *key = @(SRGPlaylistURLQualityForString([rawURLDict objectForKey:@"@quality"]));
            NSURL *value = [NSURL URLWithString:[rawURLDict objectForKey:@"text"]];
            if (key && value) {
                tmp[key] = value;
            }
        }
        _URLs = [NSDictionary dictionaryWithDictionary:tmp];
    }
    
    return self;
}

- (NSURL *)URLForQuality:(SRGPlaylistURLQuality)quality
{
    return [_URLs objectForKey:@(quality)];
}


@end
