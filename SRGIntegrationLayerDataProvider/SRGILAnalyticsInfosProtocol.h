//
//  SRGIndividualDataSource.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILMedia.h"

@protocol SRGILAnalyticsInfos <NSObject>

- (instancetype)initWithMedia:(SRGILMedia *)media;

@end
