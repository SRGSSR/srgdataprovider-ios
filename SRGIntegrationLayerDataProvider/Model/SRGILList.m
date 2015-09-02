//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
