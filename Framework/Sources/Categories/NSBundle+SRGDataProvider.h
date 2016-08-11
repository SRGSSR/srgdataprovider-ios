//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#define SRGDataProviderLocalizedString(key, comment) [[NSBundle srg_dataProviderBundle] localizedStringForKey:(key) value:@"" table:nil]

@interface NSBundle (SRGDataProvider)

+ (NSBundle *)srg_dataProviderBundle;

@end
