//
//  SRGILURLComponents+Private.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 08/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILURLComponents.h"

@interface SRGILURLComponents ()

+ (nullable SRGILURLComponents *)componentsForFetchListIndex:(SRGILFetchListIndex)index
                                              withIdentifier:(nullable NSString *)identifier
                                                       error:(NSError * __nullable __autoreleasing * __nullable)error;

@end