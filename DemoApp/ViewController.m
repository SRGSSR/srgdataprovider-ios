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

@end

@implementation ViewController

- (IBAction)startRequest:(id)sender
{
    __block SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    SRGRequest *request = [dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        NSLog(@"Medias: %@", medias);
        dataProvider = nil;
    }];
    [request resume];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
