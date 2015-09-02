//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILRubric.h"

@implementation SRGILRubric

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _title = [dictionary objectForKey:@"title"];
        _image = [[SRGILImage alloc] initWithDictionary:[dictionary objectForKey:@"Image"]];
        _primaryChannel = [[SRGILPrimaryChannel alloc] initWithDictionary:[dictionary objectForKey:@"PrimaryChannel"]];
    }
    return self;
}

@end
