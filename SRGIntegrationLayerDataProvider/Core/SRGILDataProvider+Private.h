//
//  SRGILDataProvider+Private.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProvider.h"

#if __has_include("SRGILOfflineMetadataProvider.h")
#import "SRGILOfflineMetadataProvider.h"
#endif

@class SRGILRequestsManager;

@interface  SRGILDataProvider ()

@property(nonatomic, strong) NSMutableDictionary *identifiedMedias;
@property(nonatomic, strong) NSMutableDictionary *identifiedShows;

@property(nonatomic, strong) SRGILRequestsManager *requestManager;

@end