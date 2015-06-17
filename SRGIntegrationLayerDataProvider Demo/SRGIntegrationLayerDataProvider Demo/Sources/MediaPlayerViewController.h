//
//  MediaPlayerViewController.h
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <UIKit/UIKit.h>

@interface MediaPlayerViewController : UIViewController <RTSSegmentedTimelineViewDelegate, RTSTimeSliderDelegate>

@property (nonatomic, copy) NSString *videoIdentifier;

@end
