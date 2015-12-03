//
//  SRGILSonglog.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILModelObject.h"

@class SRGILSong;

@interface SRGILSonglog : SRGILModelObject

@property(nonatomic, strong) NSString *channelId;
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, strong) NSDate *playedDate;
@property(nonatomic, strong) SRGILSong *song;

@end
