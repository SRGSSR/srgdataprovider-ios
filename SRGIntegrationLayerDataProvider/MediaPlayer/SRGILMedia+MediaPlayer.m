//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGMediaPlayer/RTSMediaSegment.h>
#import "SRGILMedia+MediaPlayer.h"
#import "RTSMediaSegment.h"

@implementation SRGILMedia (MediaPlayer)

#pragma mark - RTSMediaPlayerSegment protocol

- (NSString *)segmentIdentifier
{
    // Override segment identifiers with the one of their parent for logical video segments
    if (self.type == SRGILMediaTypeVideo || self.type == SRGILMediaTypeVideoSet) {
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

- (BOOL)isLogical
{
    // Only logical segments in audio
    return (self.type == SRGILMediaTypeVideo || self.type == SRGILMediaTypeVideoSet) && !self.isFullLength;
}

- (BOOL)isVisible
{
    if (self.type == SRGILMediaTypeVideo || self.type == SRGILMediaTypeVideoSet) {
        return self.displayable && !self.isFullLength;
    }
    else {
        return self.displayable;
    }
}

@end
