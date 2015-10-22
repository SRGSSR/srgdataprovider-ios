//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILMedia+MediaPlayer.h"

@implementation SRGILMedia (MediaPlayer)

#pragma mark - RTSMediaPlayerSegment protocol

- (NSString *)segmentIdentifier
{
    return self.urnString;
}

- (CMTimeRange)timeRange
{
    return CMTimeRangeFromTimeToTime(CMTimeMakeWithSeconds(self.markIn, 1.), CMTimeMakeWithSeconds(self.markOut, 1.));
}

- (BOOL)isVisible
{
    if (self.type == SRGILMediaTypeVideo) {
        return self.displayable && !self.isFullLength;
    }
    else {
        return self.displayable;
    }
}

@end
