//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+RequestBuilders.h"

NSString *SRGStringFromDate(NSDate *date)
{
    // IL parameters are interpreted in the IL timezone (expected to be Zurich). Convert to Zurich dates so that the
    // returned objects have dates which, when converted back to the local timezone, match the original date specified.
    static dispatch_once_t s_onceToken;
    static NSDateFormatter *s_dateFormatter;
    dispatch_once(&s_onceToken, ^{
        s_dateFormatter = [[NSDateFormatter alloc] init];
        [s_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [s_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Zurich"]];
        [s_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    });
    return [s_dateFormatter stringFromDate:date];
}

NSString *SRGPathComponentForVendor(SRGVendor vendor)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_pathComponents;
    dispatch_once(&s_onceToken, ^{
        s_pathComponents = @{ @(SRGVendorRSI) : @"rsi",
                              @(SRGVendorRTR) : @"rtr",
                              @(SRGVendorRTS) : @"rts",
                              @(SRGVendorSRF) : @"srf",
                              @(SRGVendorSWI) : @"swi",
                              @(SRGVendorSSATR) : @"ssatr" };
    });
    return s_pathComponents[@(vendor)] ?: @"not_supported";
}

NSString *SRGPathComponentForModuleType(SRGModuleType moduleType)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_pathComponents;
    dispatch_once(&s_onceToken, ^{
        s_pathComponents = @{ @(SRGModuleTypeEvent) : @"event" };
    });
    return s_pathComponents[@(moduleType)] ?: @"not_supported";
}

@implementation SRGDataProvider (RequestBuilders)

- (NSURLRequest *)URLRequestForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [self.serviceURL URLByAppendingPathComponent:resourcePath];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    [self.globalParameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:name value:value]];
    }];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"vector" value:@"appplay"]];
    URLComponents.queryItems = fullQueryItems.copy;
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URLComponents.URL];
    [self.globalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull headerField, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [URLRequest setValue:value forHTTPHeaderField:headerField];
    }];
    return URLRequest.copy;              // Not an immutable copy ;(
}

@end
