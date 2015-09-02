//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILImageRepresentation.h"

@implementation SRGILImageRepresentation

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        _usage = SRGILMediaImageUsageFromString([dictionary objectForKey:@"usage"]);
        _size = CGSizeZero;
        if ([dictionary objectForKey:@"height"]) {
            _size.height = [[dictionary objectForKey:@"height"] doubleValue];
        }
        if ([dictionary objectForKey:@"width"]) {
            _size.height = [[dictionary objectForKey:@"width"] doubleValue];
        }
    }
    return self;
}

@end
