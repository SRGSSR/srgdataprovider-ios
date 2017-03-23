//
//  ViewController.m
//  DemoApp
//
//  Created by Samuel Défago on 23.03.17.
//  Copyright © 2017 SRG. All rights reserved.
//

#import "ViewController.h"

#import <SRGDataProvider/SRGDataProvider.h>

@interface ViewController ()

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
}

- (IBAction)startRequest:(id)sender
{
    __block SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@", @(medias.count));
        request = nil;
    }];
    [request resume];
}

- (IBAction)startQueue:(id)sender
{
    SRGRequestQueue *queue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        if (finished) {
            NSLog(@"Finished");
        }
        else {
            NSLog(@"Started");
        }
    }];
    
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@", @(medias.count));
    }];
    [queue addRequest:request resume:YES];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
