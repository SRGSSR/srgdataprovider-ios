//
//  MediaPlayerViewController.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "MediaPlayerViewController.h"

#import "SegmentCollectionViewCell.h"

#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h>

@interface MediaPlayerViewController ()

@property (nonatomic) NSArray *segments;

@property (nonatomic) IBOutlet RTSMediaPlayerController *mediaPlayerController;
@property (nonatomic) SRGILDataProvider *dataSource;

@property (nonatomic, weak) IBOutlet RTSTimelineView *timelineView;

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

#pragma mark - Getters and setters

- (void)setVideoIdentifier:(NSString *)videoIdentifier
{
	_videoIdentifier = videoIdentifier;
	
	[self.mediaPlayerController playIdentifier:videoIdentifier];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

#pragma mark - RTSTimelineViewDelegate protocol

- (UICollectionViewCell *)timelineView:(RTSTimelineView *)timelineView cellForSegment:(RTSMediaPlayerSegment *)segment
{
    return [timelineView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SegmentCollectionViewCell class]) forSegment:segment];
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
