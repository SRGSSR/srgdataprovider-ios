//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Convenience macro for localized strings associated with the framework.
 */
#define SRGDataProviderLocalizedString(key, comment) [NSBundle.srg_dataProviderBundle localizedStringForKey:(key) value:@"" table:nil]

/**
 *  Return an accessibility-oriented localized string associated with the framework.
 */
#define SRGDataProviderAccessibilityLocalizedString(key, comment) [NSBundle.srg_dataProviderBundle localizedStringForKey:(key) value:@"" table:@"Accessibility"]

/**
 *  Data provider extensions to `NSBundle`.
 */
@interface NSBundle (SRGDataProvider)

/**
 *  The data provider resource bundle.
 */
@property (class, nonatomic, readonly) NSBundle *srg_dataProviderBundle;

@end

NS_ASSUME_NONNULL_END
