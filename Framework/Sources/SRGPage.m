//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

#import "SRGDataProviderLogger.h"

#import <libextobjc/libextobjc.h>

@interface SRGPage ()

@property (nonatomic) NSURLRequest *originalURLRequest;
@property (nonatomic) NSUInteger size;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGPage

#pragma mark Class methods

// Attempt to split a URL into URNs pages, client-side. If not possible or if there is no page with the specified
// number, the method returns `nil`.
+ (SRGPage *)pageForURNsInOriginalURLRequest:(NSURLRequest *)URLRequest withSize:(NSUInteger)size number:(NSUInteger)number
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URLRequest.URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryItems = [URLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(NSURLQueryItem.new, name), @"urns"];
    NSURLQueryItem *URNsQueryItem = [URLComponents.queryItems filteredArrayUsingPredicate:predicate].firstObject;
    
    if (! URNsQueryItem.value) {
        return nil;
    }
    
    static NSString * const kURNsSeparator = @",";
    NSArray<NSString *> *URNs = [URNsQueryItem.value componentsSeparatedByString:kURNsSeparator];
    if (number == 0 && URNs.count < 2) {
        return [[self.class alloc] initWithOriginalURLRequest:URLRequest size:size number:0 URL:URLRequest.URL];
    }
    
    NSUInteger location = number * size;
    if (location >= URNs.count) {
        return nil;
    }
    
    NSRange range = NSMakeRange(location, MIN(size, URNs.count - location));
    NSArray<NSString *> *pageURNs = [URNs subarrayWithRange:range];
    NSURLQueryItem *pageURNsQueryItem = [NSURLQueryItem queryItemWithName:@"urns" value:[pageURNs componentsJoinedByString:kURNsSeparator]];
    [queryItems replaceObjectAtIndex:[queryItems indexOfObject:URNsQueryItem] withObject:pageURNsQueryItem];
    
    URLComponents.queryItems = [queryItems copy];
    return [[self.class alloc] initWithOriginalURLRequest:URLRequest size:size number:number URL:URLComponents.URL];
}

+ (SRGPage *)firstPageForOriginalURLRequest:(NSURLRequest *)originalURLRequest withSize:(NSUInteger)size
{
    SRGPage *page = [self pageForURNsInOriginalURLRequest:originalURLRequest withSize:size number:0];
    if (page) {
        return page;
    }
    
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:originalURLRequest.URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryItems = [URLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", @keypath(NSURLQueryItem.new, name), @"pageSize"];
    [queryItems filterUsingPredicate:predicate];
    
    NSString *pageSize = (size != SRGPageUnlimitedSize) ? @(size).stringValue : @"unlimited";
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:pageSize]];
    
    URLComponents.queryItems = [queryItems copy];
    return [[self.class alloc] initWithOriginalURLRequest:originalURLRequest size:size number:0 URL:URLComponents.URL];
}

#pragma mark Object lifecycle

- (SRGPage *)initWithOriginalURLRequest:(NSURLRequest *)originalURLRequest size:(NSUInteger)size number:(NSUInteger)number URL:(NSURL *)URL
{
    NSParameterAssert(originalURLRequest);
    NSParameterAssert(URL);
    
    if (size < 1) {
        SRGDataProviderLogWarning(@"page", @"The minimum page size is 1. This minimum value will be used.");
        size = 1;
    }
    else if (size > SRGPageMaximumSize && size != SRGPageUnlimitedSize) {
        SRGDataProviderLogWarning(@"page", @"The maximum page size for this request is %@. This maximum value will be used.", @(SRGPageMaximumSize));
        size = SRGPageMaximumSize;
    }
    
    if (self = [super init]) {
        self.originalURLRequest = originalURLRequest;
        self.number = MAX(number, 0);
        self.size = size;
        self.URL = URL;
    }
    return self;
}

#pragma mark Getters and setters

- (NSURLRequest *)URLRequest
{
    NSURL *URL = self.URL;
    NSURLRequest *originalURLRequest = self.originalURLRequest;
    
    if (! [URL.host isEqualToString:originalURLRequest.URL.host]) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
        URLComponents.host = originalURLRequest.URL.host;
        URL = URLComponents.URL;
    }
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    [originalURLRequest.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull field, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [URLRequest setValue:value forHTTPHeaderField:field];
    }];
    return [URLRequest copy];
}

#pragma mark Helpers

- (SRGPage *)nextPageWithURL:(NSURL *)URL
{
    if (URL) {
        return [[self.class alloc] initWithOriginalURLRequest:self.originalURLRequest size:self.size number:self.number + 1 URL:URL];
    }
    else {
        return [self.class pageForURNsInOriginalURLRequest:self.originalURLRequest withSize:self.size number:self.number + 1];
    }
}

- (SRGPage *)firstPageWithSize:(NSUInteger)size
{
    return [SRGPage firstPageForOriginalURLRequest:self.originalURLRequest withSize:size];
}

- (SRGPage *)firstPage
{
    return [self firstPageWithSize:self.size];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGPage *otherPage = object;
    return self.size == otherPage.size && self.number == otherPage.number && (self.URL == otherPage.URL || [self.URL isEqual:otherPage.URL]);
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@_%@_%@", @(self.size), @(self.number), self.URL.absoluteString].hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[self.class allocWithZone:zone] initWithOriginalURLRequest:self.originalURLRequest size:self.size number:self.number URL:self.URL];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; URL = %@; size = %@; number = %@>",
            self.class,
            self,
            self.URL,
            self.size == SRGPageUnlimitedSize ? @"unlimited" : @(self.size),
            @(self.number)];
}

@end
