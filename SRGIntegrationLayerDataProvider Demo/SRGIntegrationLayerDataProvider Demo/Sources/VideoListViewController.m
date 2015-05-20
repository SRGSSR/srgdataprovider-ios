//
//  VideoListViewController.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "VideoListViewController.h"

#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h>

@implementation VideoListViewController

#pragma mark UITableViewDataSource protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // FIXME: Issue with nib loading on the iPad
    if (indexPath.section == 0 && indexPath.row == 0) {
        // FIXME: The provider must unregister from the notification center, otherwise crashes will occur on notifications
        SRGILDataProvider *dataSource = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
        RTSMediaPlayerViewController *mediaPlayerViewController = [[RTSMediaPlayerViewController alloc] initWithContentIdentifier:@"6795800" dataSource:dataSource];
        [self presentViewController:mediaPlayerViewController animated:YES completion:nil];
    }
}

@end
