//
//  SegmentCollectionViewCell.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 21.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SegmentCollectionViewCell.h"

static NSString *sexagesimalDurationStringFromValue(NSInteger duration)
{
    NSInteger hours = duration / 3600;
    NSInteger minutes = (duration % 3600) / 60;
    NSInteger seconds = (duration % 3600) % 60;
    
    NSString *minutesAndSeconds = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    
    return (hours > 0) ? [[NSString stringWithFormat:@"%01ld:", (long)hours] stringByAppendingString:minutesAndSeconds] : minutesAndSeconds;
}

@interface SegmentCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;

@end

@implementation SegmentCollectionViewCell

- (void)setSegment:(SRGILVideo *)segment
{
    _segment = segment;
    
    self.titleLabel.text = segment.title;
    self.durationLabel.text = sexagesimalDurationStringFromValue(segment.duration);
}

@end
