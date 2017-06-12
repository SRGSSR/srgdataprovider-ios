//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSHTTPURLResponse+SRGDataProvider.h"

@implementation NSHTTPURLResponse (SRGDataProvider)

+ (NSString *)play_localizedStringForStatusCode:(NSInteger)statusCode
{
    NSString *localizationKey = [self localizedStringForStatusCode:statusCode];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.apple.CFNetwork"];
    NSString *localizedString = [bundle localizedStringForKey:localizationKey value:localizationKey table:nil];
    NSString *capitalizedFirstLetter = [[localizedString substringToIndex:1] uppercaseStringWithLocale:[NSLocale currentLocale]];
    return [localizedString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:capitalizedFirstLetter];
}

@end
