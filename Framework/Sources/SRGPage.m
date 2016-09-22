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
@property (nonatomic, copy) NSString *uid;

@end

@implementation SRGPage

#pragma mark Class methods

+ (SRGPage *)firstPageWithDefaultSize
{
    return [self firstPageWithSize:SRGPageDefaultSize];
}

+ (SRGPage *)firstPageWithSize:(NSUInteger)size
{
    return [[[self class] alloc] initWithSize:size number:0 uid:nil];
}

#pragma mark Object lifecycle

- (SRGPage *)initWithSize:(NSInteger)size number:(NSInteger)number uid:(NSString *)uid
{
    if (self = [super init]) {
        self.size = MAX(size, 1);
        self.number = MAX(number, 0);
        self.uid = uid;
    }
    return self;
}

#pragma mark Getters and setters

- (NSURLQueryItem *)queryItem
{
    if (self.uid) {
        return [NSURLQueryItem queryItemWithName:@"next" value:self.uid];
    }
    else if (self.size != SRGPageDefaultSize) {
        return [NSURLQueryItem queryItemWithName:@"pageSize" value:@(self.size).stringValue];
    }
    else {
        return nil;
    }
}

#pragma mark Helpers

- (SRGPage *)previousPageWithUid:(NSString *)uid
{
    if (self.number == 0) {
        return nil;
    }
    
    return [[[self class] alloc] initWithSize:self.size number:self.number - 1 uid:uid];
}

- (SRGPage *)nextPageWithUid:(NSString *)uid
{
    return [[[self class] alloc] initWithSize:self.size number:self.number + 1 uid:uid];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[SRGPage class]]) {
        return NO;
    }
    
    SRGPage *otherPage = object;
    return [self.uid isEqualToString:otherPage.uid];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[SRGPage allocWithZone:zone] initWithSize:self.size number:self.number uid:self.uid];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; size: %@; number: %@; uid: %@>",
            [self class],
            self,
            self.size == SRGPageDefaultSize ? @"default" : @(self.size),
            @(self.number),
            self.uid];
}

@end
