//
//  SRGPlaylist.m
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 20/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILPlaylist.h"

@interface SRGILPlaylist()

@property(nonatomic) SRGILPlaylistProtocol protocol;
@property(nonatomic) SRGILPlaylistSegmentation segmentation;
@property(nonatomic) SRGILPlaylistURLQuality quality;
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
        _protocol = SRGILPlayListProtocolForString([dictionary objectForKey:@"@protocol"]);
        _segmentation = SRGILPlaylistSegmentationForString([dictionary objectForKey:@"@segmentation"]);
        
        NSArray *rawURLs = [dictionary objectForKey:@"url"];
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        for (NSDictionary *rawURLDict in rawURLs) {
            NSNumber *key = @(SRGILPlaylistURLQualityForString([rawURLDict objectForKey:@"@quality"]));
            NSURL *value = [NSURL URLWithString:[rawURLDict objectForKey:@"text"]];
            if (key && value) {
                tmp[key] = value;
            }
        }
        _URLs = [NSDictionary dictionaryWithDictionary:tmp];
    }
    
    return self;
}

- (NSURL *)URLForQuality:(SRGILPlaylistURLQuality)quality
{
    return [_URLs objectForKey:@(quality)];
}


@end
