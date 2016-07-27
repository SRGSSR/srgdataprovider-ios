//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

@interface SRGPage ()

@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger size;

@end

@implementation SRGPage

#pragma mark Class methods

+ (SRGPage *)pageWithNumber:(NSInteger)number size:(NSInteger)size
{
    return [[[self class] alloc] initWithNumber:number size:size];
}

#pragma mark Object lifecycle

- (SRGPage *)initWithNumber:(NSInteger)number size:(NSInteger)size
{
    if (self = [super init]) {
        self.number = MAX(number, 1);
        self.size = MAX(size, 1);
    }
    return self;
}

#pragma mark Helpers

- (SRGPage *)previousPage
{
    if (self.number == 1) {
        return nil;
    }
    
    return [[self class] pageWithNumber:self.number - 1 size:self.size];
}

- (SRGPage *)nextPage
{
    return [[self class] pageWithNumber:self.number + 1 size:self.size];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[SRGPage class]]) {
        return NO;
    }
    
    SRGPage *otherPage = object;
    return self.number == otherPage.number && self.size == otherPage.size;
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@_%@", @(self.number), @(self.size)].hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[SRGPage allocWithZone:zone] initWithNumber:self.number size:self.size];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; number: %@; size: %@>",
            [self class],
            self,
            @(self.number),
            @(self.size)];
}

@end