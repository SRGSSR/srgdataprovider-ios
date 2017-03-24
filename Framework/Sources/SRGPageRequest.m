//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPageRequest.h"

#import "SRGRequest+Private.h"

@implementation SRGPageRequest

// Inherited from hidden parent property
@dynamic page;

#pragma mark Page management

- (SRGRequest *)withPageSize:(NSInteger)pageSize
{
    return [super withPageSize:pageSize];
}

- (SRGRequest *)atPage:(SRGPage *)page
{
    return [super atPage:page];
}

@end
