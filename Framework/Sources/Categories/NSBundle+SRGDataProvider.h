//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 *  Convenience macro for localized strings associated with the framework
 */
#define SRGDataProviderLocalizedString(key, comment) [[NSBundle srg_dataProviderBundle] localizedStringForKey:(key) value:@"" table:nil]

@interface NSBundle (SRGDataProvider)

/**
 *  The data provider resource bundle
 */
+ (NSBundle *)srg_dataProviderBundle;

@end
