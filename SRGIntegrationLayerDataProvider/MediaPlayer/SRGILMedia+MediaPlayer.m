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
    // Override segment identifiers with the one of their parent for logical video segments
    if (self.type == SRGILMediaTypeVideo) {
        return self.parent.urnString ?: self.urnString;
    }
    else {
        return self.urnString;
    }
}

- (CMTimeRange)timeRange
{
    NSTimeInterval markOunt = (self.markOut > 0) ? self.markOut : self.markIn + self.duration;
    return CMTimeRangeFromTimeToTime(CMTimeMakeWithSeconds(self.markIn, 1.), CMTimeMakeWithSeconds(markOunt, 1.));
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
