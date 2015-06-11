//
//  SRGILDataProviderConstants.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 11/06/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SRGILDataProviderErrorDomain;

typedef NS_ENUM(NSInteger, SRGILDataProviderErrorCode) {
    SRGILDataProviderErrorCodeInvalidFetchIndex,
    SRGILDataProviderErrorCodeInvalidPathArgument,
};