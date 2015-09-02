//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
