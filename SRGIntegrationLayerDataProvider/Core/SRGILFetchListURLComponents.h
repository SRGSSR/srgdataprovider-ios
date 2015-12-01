//
//  SRGILFetchPath.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 01/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProviderConstants.h"

@interface SRGILFetchListURLComponents : NSURLComponents

@property(nonatomic, assign) SRGILFetchListIndex index;

+ (nullable SRGILFetchListURLComponents *)URLComponentsForFetchListIndex:(SRGILFetchListIndex)index
                                                          withIdentifier:(nullable NSString *)identifier
                                                                   error:(NSError * __nullable __autoreleasing * __nullable)error;

- (void)updateArguments:(nullable  NSArray <NSURLQueryItem *> *)newArguments;

@end
