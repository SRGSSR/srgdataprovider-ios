//
//  MediaPlayerViewController.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h>

#import "MediaPlayerViewController.h"
#import "SegmentCollectionViewCell.h"
#import "AppDelegate.h"

@interface MediaPlayerViewController ()

@property (nonatomic) NSArray *segments;

@property (nonatomic) IBOutlet RTSMediaPlayerController *mediaPlayerController;
@property (nonatomic) IBOutlet RTSMediaSegmentsController *mediaSegmentsController;

@property (nonatomic) SRGILDataProvider *dataSource;

@property (nonatomic, weak) IBOutlet RTSSegmentedTimelineView *timelineView;
@property (nonatomic, weak) IBOutlet RTSTimeSlider *timeSlider;

@property (nonatomic, weak) id playbackTimeObserver;

@end

@implementation MediaPlayerViewController

#pragma mark - Object lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.dataSource = appDelegate.dataSource;
    }
    return self;
}

- (void)dealloc
{
    // Remove time observers
    self.mediaPlayerController = nil;
}

#pragma mark - Getters and setters

- (void)setMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
    if (_mediaPlayerController) {
        [_mediaPlayerController removePeriodicTimeObserver:self.playbackTimeObserver];
    }
    
    _mediaPlayerController = mediaPlayerController;
    
    if (mediaPlayerController) {
        self.playbackTimeObserver = [mediaPlayerController addPeriodicTimeObserverForInterval:CMTimeMake(1., 5.) queue:NULL usingBlock:^(CMTime time) {
            [self updateAppearanceWithTime:time];
        }];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

    self.mediaPlayerController.dataSource = self.dataSource;
    self.mediaSegmentsController.dataSource = self.dataSource;

    NSString *className = NSStringFromClass([SegmentCollectionViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.timelineView registerNib:nib forCellWithReuseIdentifier:className];
    
	[self.mediaPlayerController attachPlayerToView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mediaPlayerController playIdentifier:self.videoIdentifier];

	if ([self isMovingToParentViewController] || [self isBeingPresented]) {
		[self.mediaPlayerController playIdentifier:self.videoIdentifier];
        [self.timelineView reloadSegmentsForIdentifier:self.videoIdentifier completionHandler:nil];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if ([self isMovingFromParentViewController] || [self isBeingDismissed]) {
		[self.mediaPlayerController reset];
	}
}

#pragma mark - UI

- (void)updateAppearanceWithTime:(CMTime)time
{
    for (SegmentCollectionViewCell *segmentCell in [self.timelineView visibleCells]) {
        [segmentCell updateAppearanceWithTime:time];
    }
}

#pragma mark - RTSTimelineViewDelegate protocol

- (UICollectionViewCell *)timelineView:(RTSSegmentedTimelineView *)timelineView cellForSegment:(id<RTSMediaSegment>)segment
{
    SegmentCollectionViewCell *segmentCell = (SegmentCollectionViewCell *)[timelineView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SegmentCollectionViewCell class]) forSegment:segment];
    segmentCell.segment = segment;
    return segmentCell;
}

#pragma ark - RTSTimeSliderDelegate protocol

- (void)timeSlider:(RTSTimeSlider *)slider isMovingToPlaybackTime:(CMTime)time withValue:(CGFloat)value interactive:(BOOL)interactive
{
    [self updateAppearanceWithTime:time];
    
    if (interactive) {
        NSUInteger visibleSegmentIndex = [self.timelineView.segmentsController indexOfVisibleSegmentForTime:time];
        if (visibleSegmentIndex != NSNotFound) {
            id<RTSMediaSegment> segment = [[self.timelineView.segmentsController visibleSegments] objectAtIndex:visibleSegmentIndex];
            [self.timelineView scrollToSegment:segment animated:YES];
        }        
    }
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
