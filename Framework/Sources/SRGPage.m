//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

static const NSInteger SRGPageDefaultSize = NSIntegerMax;

@interface SRGPage ()

@property (nonatomic) NSInteger size;
@property (nonatomic) NSInteger number;
@property (nonatomic, copy) NSString *path;

@end

@implementation SRGPage

#pragma mark Class methods

+ (SRGPage *)firstPageWithDefaultSize
{
    return [self firstPageWithSize:SRGPageDefaultSize];
}

+ (SRGPage *)firstPageWithSize:(NSUInteger)size
{
    return [[[self class] alloc] initWithSize:size number:0 path:nil];
}

+ (NSURLRequest *)request:(NSURLRequest *)request withPage:(SRGPage *)page
{
    if (page.path) {
        NSMutableURLRequest *nextRequest = [request mutableCopy];
        nextRequest.URL = [NSURL URLWithString:page.path relativeToURL:request.URL.baseURL];
        return [nextRequest copy];
    }
    else if (page.size != SRGPageDefaultSize) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        URLComponents.queryItems = [URLComponents.queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:@(page.size).stringValue]];
        
        NSMutableURLRequest *sizeRequest = [request mutableCopy];
        sizeRequest.URL = URLComponents.URL;
        return [sizeRequest copy];
    }
    else {
        return [request copy];
    }
}

#pragma mark Object lifecycle

- (SRGPage *)initWithSize:(NSInteger)size number:(NSInteger)number path:(NSString *)path
{
    if (self = [super init]) {
        self.size = MAX(size, 1);
        self.number = MAX(number, 0);
        self.path = path;
    }
    return self;
}

#pragma mark Helpers

- (SRGPage *)nextPageWithPath:(NSString *)path
{
    return [[[self class] alloc] initWithSize:self.size number:self.number + 1 path:path];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[SRGPage class]]) {
        return NO;
    }
    
    SRGPage *otherPage = object;
    return self.size == otherPage.size && self.number == otherPage.number && [self.path isEqualToString:otherPage.path];
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@_%@_%@", @(self.size), @(self.number), self.path].hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[SRGPage allocWithZone:zone] initWithSize:self.size number:self.number path:self.path];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; size: %@; number: %@; path: %@>",
            [self class],
            self,
            self.size == SRGPageDefaultSize ? @"default" : @(self.size),
            @(self.number),
            self.path];
}

@end
