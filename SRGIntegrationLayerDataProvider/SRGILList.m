//
//  SRGILList.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 08/09/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILList.h"

@interface SRGILList () {
    NSArray *_storage;
}
@end

@implementation SRGILList

- (id)initWithArray:(NSArray *)array
{
    self = [self init];
    if (self) {
        _storage = [[NSArray alloc] initWithArray:array];
    }
    return self;
}

- (NSUInteger)count
{
    return [_storage count];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [_storage objectAtIndex:index];
}

@end
