//
//  SRGIndividualDataSource.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRGAnalyticsIndividualDataSource <NSObject>

- (instancetype)initWithIdentifier:(NSString *)identifier;

@end
