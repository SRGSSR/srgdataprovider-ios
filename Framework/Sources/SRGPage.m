//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

#import "SRGDataProviderLogger.h"

#import <libextobjc/libextobjc.h>

const NSUInteger SRGPageDefaultSize = 10;
const NSUInteger SRGPageMaximumSize = 100;
const NSUInteger SRGPageUnlimitedSize = NSUIntegerMax;

@interface SRGPage ()

@property (nonatomic) NSURLRequest *originalRequest;
@property (nonatomic) NSUInteger size;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGPage

#pragma mark Class methods

// Attempt to split a URL into URNs pages, client-side. If not possible or if there is no page with the specified
// number, return `nil`.
+ (SRGPage *)pageForURNsInOriginalRequest:(NSURLRequest *)request withSize:(NSUInteger)size number:(NSUInteger)number
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryItems = [URLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(NSURLQueryItem.new, name), @"urns"];
    NSURLQueryItem *URNsQueryItem = [URLComponents.queryItems filteredArrayUsingPredicate:predicate].firstObject;
    
    if (! URNsQueryItem.value) {
        return nil;
    }
    
    static NSString * const kURNsSeparator = @",";
    NSArray<NSString *> *URNs = [URNsQueryItem.value componentsSeparatedByString:kURNsSeparator];
    if (number == 0 && URNs.count < 2) {
        return [[self.class alloc] initWithOriginalRequest:request size:size number:0 URL:request.URL];
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
    return [[self.class alloc] initWithOriginalRequest:request size:size number:number URL:URLComponents.URL];
}

+ (SRGPage *)firstPageForOriginalRequest:(NSURLRequest *)originalRequest withSize:(NSUInteger)size
{
    SRGPage *page = [self pageForURNsInOriginalRequest:originalRequest withSize:size number:0];
    if (page) {
        return page;
    }
    
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:originalRequest.URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryItems = [URLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", @keypath(NSURLQueryItem.new, name), @"pageSize"];
    [queryItems filterUsingPredicate:predicate];
    
    NSString *pageSize = (size != SRGPageUnlimitedSize) ? @(size).stringValue : @"unlimited";
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:pageSize]];
    
    URLComponents.queryItems = [queryItems copy];
    return [[self.class alloc] initWithOriginalRequest:originalRequest size:size number:0 URL:URLComponents.URL];
}

#pragma mark Object lifecycle

- (SRGPage *)initWithOriginalRequest:(NSURLRequest *)originalRequest size:(NSUInteger)size number:(NSUInteger)number URL:(NSURL *)URL
{
    NSParameterAssert(originalRequest);
    
    if (size < 1) {
        SRGDataProviderLogWarning(@"page", @"The minimum page size is 1. This minimum value will be used.");
        size = 1;
    }
    else if (size > SRGPageMaximumSize && size != SRGPageUnlimitedSize) {
        SRGDataProviderLogWarning(@"page", @"The maximum page size for this request is %@. This maximum value will be used.", @(SRGPageMaximumSize));
        size = SRGPageMaximumSize;
    }
    
    if (self = [super init]) {
        self.originalRequest = originalRequest;
        self.number = MAX(number, 0);
        self.size = size;
        self.URL = URL;
    }
    return self;
}

#pragma mark Getters and setters

- (NSURLRequest *)request
{
    NSURL *URL = self.URL;
    NSURLRequest *originalRequest = self.originalRequest;
    
    if (! [URL.host isEqualToString:originalRequest.URL.host]) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
        URLComponents.host = originalRequest.URL.host;
        URL = URLComponents.URL;
    }
    
    NSMutableURLRequest *pageRequest = [NSMutableURLRequest requestWithURL:URL];
    [originalRequest.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull field, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [pageRequest setValue:value forHTTPHeaderField:field];
    }];
    return [pageRequest copy];
}

#pragma mark Helpers

- (SRGPage *)nextPageWithURL:(NSURL *)URL
{
    if (URL) {
        return [[self.class alloc] initWithOriginalRequest:self.originalRequest size:self.size number:self.number + 1 URL:URL];
    }
    else {
        return [self.class pageForURNsInOriginalRequest:self.originalRequest withSize:self.size number:self.number + 1];
    }
}

- (SRGPage *)firstPageWithSize:(NSUInteger)size
{
    return [SRGPage firstPageForOriginalRequest:self.originalRequest withSize:size];
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
    return [[self.class allocWithZone:zone] initWithOriginalRequest:self.originalRequest size:self.size number:self.number URL:self.URL];
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
