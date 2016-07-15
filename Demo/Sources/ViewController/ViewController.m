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
    NSURLSessionTask *task = [[SRGDataProvider currentDataProvider] listTopicsWithCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        NSLog(@"Topics: %@", topics);
    }];
    [task resume];
}

@end
