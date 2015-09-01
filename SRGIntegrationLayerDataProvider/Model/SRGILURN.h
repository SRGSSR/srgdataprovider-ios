//
//  SRGILURN.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 29/06/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"

@interface SRGILURN : NSObject

@property(nonatomic, strong, readonly) NSString *prefix;
@property(nonatomic, strong, readonly) NSString *businessUnit;
@property(nonatomic, assign, readonly) SRGILMediaType mediaType;
@property(nonatomic, strong, readonly) NSString *identifier;

+ (SRGILURN *)URNWithString:(NSString *)urnString;
+ (NSString *)identifierForURNString:(NSString *)urnString;

@end
