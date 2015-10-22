//
//  NSBundle+SRGILDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 19/10/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SRGILDataProviderLocalizedString(key, comment) [[NSBundle SRGILDataProviderBundle] localizedStringForKey:(key) value:@"" table:nil]

@interface NSBundle (SRGILDataProvider)

+ (instancetype)SRGILDataProviderBundle;

@end
