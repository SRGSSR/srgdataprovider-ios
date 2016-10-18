//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

#import <libextobjc/libextobjc.h>

const NSInteger SRGPageDefaultSize = NSIntegerMax;

@interface SRGPage ()

@property (nonatomic) NSInteger size;
@property (nonatomic) NSInteger number;
@property (nonatomic) NSURL *URL;

@end

@implementation SRGPage

#pragma mark Class methods

+ (NSURLRequest *)request:(NSURLRequest *)request withPage:(SRGPage *)page
{
    if (page.URL) {
        return [NSURLRequest requestWithURL:page.URL];
    }
    else if (page && page.size != SRGPageDefaultSize) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSMutableArray *queryItems = [NSMutableArray arrayWithObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:@(page.size).stringValue]];
        if (URLComponents.queryItems) {
            [queryItems addObjectsFromArray:URLComponents.queryItems];
        }
        URLComponents.queryItems = [queryItems copy];
        
        NSMutableURLRequest *sizeRequest = [request mutableCopy];
        sizeRequest.URL = URLComponents.URL;
        return [sizeRequest copy];
    }
    else {
        return [request copy];
    }
}

+ (SRGPage *)firstPageWithDefaultSize
{
    return [self firstPageWithSize:SRGPageDefaultSize];
}

+ (SRGPage *)firstPageWithSize:(NSInteger)size
{
    return [[[self class] alloc] initWithSize:size number:0 URL:nil];
}

#pragma mark Object lifecycle

- (SRGPage *)initWithSize:(NSInteger)size number:(NSInteger)number URL:(NSURL *)URL
{
    if (self = [super init]) {
        self.size = MAX(size, 1);
        self.number = MAX(number, 0);
        self.URL = URL;
    }
    return self;
}

#pragma mark Helpers

- (SRGPage *)nextPageWithURL:(NSURL *)URL
{
    return [[[self class] alloc] initWithSize:self.size number:self.number + 1 URL:URL];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[SRGPage class]]) {
        return NO;
    }
    
    SRGPage *otherPage = object;
    return self.size == otherPage.size && self.number == otherPage.number && [self.URL isEqual:otherPage.URL];
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@_%@_%@", @(self.size), @(self.number), self.URL.absoluteString].hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[SRGPage allocWithZone:zone] initWithSize:self.size number:self.number URL:self.URL];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; size: %@; number: %@; URL: %@>",
            [self class],
            self,
            self.size == SRGPageDefaultSize ? @"default" : @(self.size),
            @(self.number),
            self.URL];
}

@end
