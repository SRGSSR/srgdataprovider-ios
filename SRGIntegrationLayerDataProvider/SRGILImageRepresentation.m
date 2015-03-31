//
//  SRGImageRepresentation.m
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
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
