//
//  SRGIntegrationLayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

/**
 *  `kSRGIntegrationLayerDataProvider` MUST match the Pod tag version!
 */
#define kSRGIntegrationLayerDataProvider @"0.5.0"

#import "SRGILModel.h"
#import "SRGILList.h"
#import "SRGILDataProvider.h"
#import "SRGILDataProviderConstants.h"

#if __has_include("SRGILDataProviderMediaPlayerDataSource.h")
#import "SRGILDataProviderMediaPlayerDataSource.h"
#endif

#if __has_include("SRGILDataProviderOfflineStorage.h")
#import "SRGILDataProviderOfflineStorage.h"
#endif
