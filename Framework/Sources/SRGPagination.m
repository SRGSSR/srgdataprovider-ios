//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPagination.h"

@interface SRGPagination ()

@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger size;

@end

@implementation SRGPagination

#pragma mark Class methods

+ (SRGPagination *)paginationForPage:(NSInteger)page ofSize:(NSInteger)size
{
    return [[[self class] alloc] initForPage:page ofSize:size];
}

#pragma mark Object lifecycle

- (SRGPagination *)initForPage:(NSInteger)page ofSize:(NSInteger)size
{
    if (self = [super init]) {
        self.page = MAX(page, 1);
        self.size = MAX(size, 1);
    }
    return self;
}

#pragma mark Helpers

- (SRGPagination *)paginationForPreviousPage
{
    if (self.page == 1) {
        return nil;
    }
    
    return [[self class] paginationForPage:self.page - 1 ofSize:self.size];
}

- (SRGPagination *)paginationForNextPage
{
    return [[self class] paginationForPage:self.page + 1 ofSize:self.size];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; page: %@; size: %@>",
            [self class],
            self,
            @(self.page),
            @(self.size)];
}

@end