//
//  SegmentCollectionViewCell.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 21.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SegmentCollectionViewCell.h"

#pragma mark - Functions

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
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@end

@implementation SegmentCollectionViewCell

#pragma mark - Getters and setters

- (void)setSegment:(SRGILVideo *)segment
{
    _segment = segment;
    
    self.titleLabel.text = segment.title;
    self.durationLabel.text = sexagesimalDurationStringFromValue(segment.duration);
}

#pragma mark - Overrides

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.progressView.progress = 0.f;
}

#pragma mark - UI

- (void)updateProgressWithTime:(CMTime)time
{
    float progress = (CMTimeGetSeconds(time) - self.segment.markIn) / (self.segment.markOut - self.segment.markIn);
    self.progressView.progress = fminf(1.f, fmaxf(0.f, progress));
}

@end
