//
//  SRGILDataProvider+Private.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProvider.h"

@class SRGILRequestsManager;

@protocol SRGILDataProviderSubclassingHooks <NSObject>

@optional

// An optional method which subclasses may implement to perform cleanup when the data provider is deallocated
- (void)cleanup;

@end

@interface SRGILDataProvider () <SRGILDataProviderSubclassingHooks>

@property(nonatomic, strong) NSMutableDictionary *identifiedMedias;
@property(nonatomic, strong) NSMutableDictionary *identifiedShows;

@property(nonatomic, strong) SRGILRequestsManager *requestManager;

@end

