//
//  MediaPlayerViewController.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "MediaPlayerViewController.h"

#import "SegmentCollectionViewCell.h"

#import <libextobjc/EXTScope.h>
#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h>

@interface MediaPlayerViewController ()

@property (nonatomic) NSArray *segments;

@property (nonatomic) IBOutlet RTSMediaPlayerController *mediaPlayerController;
@property (nonatomic) SRGILDataProvider *dataSource;

@property (nonatomic, weak) IBOutlet RTSTimelineView *timelineView;
@property (nonatomic, weak) IBOutlet RTSTimeSlider *timeSlider;

@property (nonatomic, weak) id playbackTimeObserver;

@end

@implementation MediaPlayerViewController

#pragma mark - Object lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.dataSource = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    }
    return self;
}

- (void)dealloc
{
    // Cleanup registrations
    self.mediaPlayerController = nil;
}

#pragma mark - Getters and setters

- (void)setVideoIdentifier:(NSString *)videoIdentifier
{
	_videoIdentifier = videoIdentifier;
	
	[self.mediaPlayerController playIdentifier:videoIdentifier];
}

- (void)setMediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
{
    if (_mediaPlayerController) {
        [_mediaPlayerController removePlaybackTimeObserver:self.playbackTimeObserver];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RTSMediaPlayerPlaybackStateDidChangeNotification object:_mediaPlayerController];
    }
    
    _mediaPlayerController = mediaPlayerController;
    
    
    if (mediaPlayerController) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateDidChange:) name:RTSMediaPlayerPlaybackStateDidChangeNotification object:_mediaPlayerController];
        
        self.playbackTimeObserver = [mediaPlayerController addPlaybackTimeObserverForInterval:CMTimeMake(1., 5.) queue:NULL usingBlock:^(CMTime time) {
            [self updateProgressWithTime:time];
        }];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.mediaPlayerController.dataSource = self.dataSource;
    self.timelineView.dataSource = self.dataSource;
    
    NSString *className = NSStringFromClass([SegmentCollectionViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.timelineView registerNib:nib forCellWithReuseIdentifier:className];
    
	[self.mediaPlayerController attachPlayerToView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	if ([self isMovingToParentViewController] || [self isBeingPresented]) {
		[self.mediaPlayerController playIdentifier:self.videoIdentifier];
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

- (void)updateProgressWithTime:(CMTime)time
{
    for (SegmentCollectionViewCell *segmentCell in [self.timelineView visibleCells]) {
        [segmentCell updateProgressWithTime:time];
    }
}

#pragma mark - RTSTimelineViewDelegate protocol

- (UICollectionViewCell *)timelineView:(RTSTimelineView *)timelineView cellForSegment:(id<RTSMediaPlayerSegment>)segment
{
    SegmentCollectionViewCell *segmentCell = (SegmentCollectionViewCell *)[timelineView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SegmentCollectionViewCell class]) forSegment:segment];
    segmentCell.segment = segment;
    return segmentCell;
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dragTimeline:(id)sender
{
    [self updateProgressWithTime:self.timeSlider.time];
}

#pragma mark - Notifications

- (void)playbackStateDidChange:(NSNotification *)notification
{
    NSAssert([notification.object isKindOfClass:[RTSMediaPlayerController class]], @"Expect a media player controller");
    
    // TODO: Currently we here use the knowledge that segment information is only available after the player is ready (since
    //       segments are retrieved when the player loads the media information). This knowledge should be the sole responsibility
    //       of the data source, though
    RTSMediaPlayerController *mediaPlayerController = (RTSMediaPlayerController *)notification.object;
    if (mediaPlayerController.playbackState == RTSMediaPlaybackStateReady) {
        [self.timelineView reloadSegmentsForIdentifier:self.videoIdentifier];
    }
}

@end
