//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <UIKit/UIKit.h>

@interface MediaPlayerViewController : UIViewController <RTSSegmentedTimelineViewDelegate, RTSTimeSliderDelegate>

@property (nonatomic, copy) NSString *videoIdentifier;

@end
