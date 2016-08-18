//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "ViewController.h"

@import SRGDataProvider;

@interface ViewController ()

@property (nonatomic) SRGRequestQueue *requestQueue;

@end

@implementation ViewController

- (IBAction)request:(id)sender
{
    [[[SRGDataProvider currentDataProvider] videoTopicsWithCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        NSLog(@"Topics: %@; error: %@", topics, error);
        
        SRGTopic *firstTopic = topics.firstObject;
        if (firstTopic) {
            [[[SRGDataProvider currentDataProvider] mostPopularVideosWithTopicUid:firstTopic.uid page:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
                NSLog(@"Medias for topic: %@; error: %@", medias, error);
            }] resume];
            
            [[[SRGDataProvider currentDataProvider] latestVideosWithTopicUid:firstTopic.uid page:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
                NSLog(@"Medias for topic: %@; error: %@", medias, error);
            }] resume];
        }
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] trendingVideosWithEditorialLimit:@5 episodesOnly:YES page:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] mediaCompositionForVideoWithUid:@"42297626" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        NSLog(@"Media composition: %@; error: %@", mediaComposition, error);
        
        [[[SRGDataProvider currentDataProvider] likeMediaComposition:mediaComposition withCompletionBlock:^(SRGLike * _Nullable like, NSError * _Nullable error) {
            NSLog(@"Like: %@; error: %@", like, error);
        }] resume];
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] mostPopularVideosWithTopicUid:nil page:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] latestVideosWithTopicUid:nil page:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] editorialVideosWithPage:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] videoShowsWithCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        NSLog(@"Shows: %@; error: %@", shows, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] searchVideosMatchingQuery:@"roger" withPage:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@; error: %@", medias, error);
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] eventsWithCompletionBlock:^(NSArray<SRGEvent *> * _Nullable events, NSError * _Nullable error) {
        NSLog(@"Events: %@; error: %@", events, error);
        
        SRGEvent *firstEvent = events.firstObject;
        if (firstEvent) {
            [[[SRGDataProvider currentDataProvider] latestVideosForEventWithUid:firstEvent.uid sectionUid:nil page:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
                NSLog(@"Medias for event: %@; error: %@", medias, error);
            }] resume];
        }
    }] resume];
    
    [[[SRGDataProvider currentDataProvider] videoChannelsWithCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        NSLog(@"Channels: %@; error: %@", channels, error);
    }] resume];
}

- (IBAction)requestQueue:(id)sender
{
    self.requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        if (finished) {
            NSLog(@"Queue finished!");
        }
        else {
            NSLog(@"Queue started!");
        }
    }];
    
    SRGRequest *request1 = [[SRGDataProvider currentDataProvider] videoTopicsWithCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        NSLog(@"Request 1 finished!");
    }];
    [self.requestQueue addRequest:request1 resume:YES];
    
    SRGRequest *request2 = [[SRGDataProvider currentDataProvider] videoShowsWithCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        NSLog(@"Request 2 finished!");
    }];
    [self.requestQueue addRequest:request2 resume:YES];
    
    SRGRequest *request3 = [[SRGDataProvider currentDataProvider] tokenizeURL:[NSURL URLWithString:@"http://srfvodhd-vh.akamaihd.net/i/vod/ts20/2016/07/ts20_20160728_193000_v_webcast_h264_,q10,q20,q30,q40,q50,q60,.mp4.csmil/master.m3u8"] withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
        NSLog(@"Request 3 finished, tokenizedURL = %@", URL);
    }];
    [self.requestQueue addRequest:request3 resume:YES];
}

@end
