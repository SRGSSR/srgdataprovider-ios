//
//  SRGIntegrationLayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

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

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif
