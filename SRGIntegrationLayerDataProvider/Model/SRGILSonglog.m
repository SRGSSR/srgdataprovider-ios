//
//  SRGILSonglog.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILSonglog.h"
#import "SRGILSong.h"

@implementation SRGILSonglog

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _channelId = dictionary[@"channelId"];
        _isPlaying = [dictionary[@"isPlaying"] boolValue];
        _song = [[SRGILSong alloc] initWithDictionary:dictionary[@"Song"]];
        
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });
        
        _playedDate = [dateFormatter dateFromString:dictionary[@"playedDate"]];
    }
    return self;
}

@end
