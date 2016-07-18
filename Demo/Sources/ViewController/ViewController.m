//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "ViewController.h"

@import SRGIntegrationLayerDataProvider;

@implementation ViewController

- (IBAction)request:(id)sender
{
    [[[SRGDataProvider currentDataProvider] videoTopicsWithCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        NSLog(@"Topics: %@; error: %@", topics, error);
        
        SRGTopic *firstTopic = topics.firstObject;
        if (firstTopic) {
            [[[SRGDataProvider currentDataProvider] latestVideosForTopicWithUid:firstTopic.uid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
                NSLog(@"Medias: %@; error: %@", medias, error);
            }] resume];
        }
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] trendingVideosWithEditorialLimit:@5 completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] compositionForVideoWithUid:@"42241186" completionBlock:^(SRGShow * _Nullable show, SRGEpisode * _Nullable episode, NSArray<SRGChapter *> * _Nullable chapters, NSError * _Nullable error) {
        NSLog(@"Show: %@; episode: %@; chapters: %@; error: %@", show, episode, chapters, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] mostPopularVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] latestVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
}

@end
