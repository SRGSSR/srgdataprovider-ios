//
//  VideoListViewController.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "VideoListViewController.h"
#import "MediaPlayerViewController.h"

@implementation VideoListViewController

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MediaPlayerViewController class]]) {
        MediaPlayerViewController *mediaPlayerViewController = (MediaPlayerViewController *)segue.destinationViewController;
        mediaPlayerViewController.videoIdentifier = segue.identifier;
    }
}

@end
