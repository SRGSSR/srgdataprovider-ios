//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <SRGIntegrationLayerDataProvider/SRGIntegrationLayerDataProvider.h>

#import "SegmentCollectionViewCell.h"
#import "SRGILModel.h"
#import "RTSMediaSegment.h"

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
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation SegmentCollectionViewCell

#pragma mark - Getters and setters

- (void)setSegment:(SRGILVideo *)segment
{
    _segment = segment;
    
    self.titleLabel.text = segment.title;
    self.durationLabel.text = sexagesimalDurationStringFromValue(segment.duration);
    
    SRGILImage *image = ([segment isFullLength] && segment.assetSet.show.image) ? segment.assetSet.show.image : segment.image;
    SRGILImageRepresentation *imgRep = [image imageRepresentationForUsage:SRGILMediaImageUsageWeb] ?: [image imageRepresentationForUsage:SRGILMediaImageUsageShowEpisode];
    NSURL *imageURL = [imgRep URL];
    
    CGFloat w = CGRectGetWidth(self.imageView.frame) * [[UIScreen mainScreen] scale];
    NSURL *completeURL = [imageURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/scale/width/%.0f", w]];
    
    [self.imageView sd_setImageWithURL:completeURL];
}

#pragma mark - Overrides

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.progressView.progress = 0.f;
}

#pragma mark - UI

- (void)updateAppearanceWithTime:(CMTime)time identifier:(NSString *)identifier
{
    if ([self.segment.segmentIdentifier isEqualToString:identifier]) {
        float progress = (CMTimeGetSeconds(time) - self.segment.markIn) / (self.segment.markOut - self.segment.markIn);
        progress = fminf(1.f, fmaxf(0.f, progress));
        
        self.progressView.progress = progress;
        self.backgroundColor = (progress != 0.f && progress != 1.f) ? [UIColor colorWithRed:128.0 / 256.0 green:0.0 / 256.0 blue:0.0 / 256.0 alpha:1.0] : [UIColor blackColor];
    }
    else {
        self.progressView.progress = 0.f;
        self.backgroundColor = [UIColor blackColor];
    }
}

@end
