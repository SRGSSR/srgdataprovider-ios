//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#define SRGDataProviderLocalizedString(key, comment) [[NSBundle srg_integrationLayerDataProviderBundle] localizedStringForKey:(key) value:@"" table:nil]

@interface NSBundle (SRGIntegrationLayerDataProvider)

+ (NSBundle *)srg_integrationLayerDataProviderBundle;

@end
