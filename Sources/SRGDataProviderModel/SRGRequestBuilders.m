//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequestBuilders.h"

@import Mantle;
@import SRGNetwork;

NSURLRequest *SRGDataProviderRequest(NSURL *serviceURL, NSString *resourcePath, NSArray<NSURLQueryItem *> *queryItems, NSDictionary<NSString *, NSString *> *headers, NSDictionary<NSString *, NSString *> *parameters)
{
    NSURL *URL = [serviceURL URLByAppendingPathComponent:resourcePath];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:name value:value]];
    }];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"vector" value:@"appplay"]];
    URLComponents.queryItems = fullQueryItems.copy;
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URLComponents.URL];
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull headerField, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [URLRequest setValue:value forHTTPHeaderField:headerField];
    }];
    return URLRequest.copy;              // Not an immutable copy ;(
}

NSArray *SRGDataProviderParseObjects(NSData *data, NSString *rootKey, Class modelClass, NSError **pError)
{
    NSDictionary *JSONDictionary = SRGNetworkJSONDictionaryParser(data, pError);
    if (! JSONDictionary) {
        return nil;
    }
    
    id JSONArray = JSONDictionary[rootKey];
    if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
        return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:pError];
    }
    else {
        // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array.
        // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
        return @[];
    }
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
