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
#define kSRGIntegrationLayerDataProvider @"0.0.3"

#import "SRGILModel.h"
#import "SRGILDataProvider.h"

#if __has_include("SRGILOfflineMetadataProvider.h")
#import "SRGILOfflineMetadataProvider.h"
#endif
