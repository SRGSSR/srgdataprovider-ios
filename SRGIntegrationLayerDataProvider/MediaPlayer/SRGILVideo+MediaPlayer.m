//
//  SRGILMedia+MediaPlayer.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Samuel Defago on 27.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILVideo+MediaPlayer.h"

@implementation SRGILVideo (MediaPlayer)

#pragma mark - RTSMediaPlayerSegment protocol

- (CMTimeRange)timeRange
{
    return CMTimeRangeFromTimeToTime(CMTimeMakeWithSeconds(self.markIn, 1.), CMTimeMakeWithSeconds(self.markOut, 1.));
}

- (BOOL)isVisible
{
    return self.displayable;
}

@end
