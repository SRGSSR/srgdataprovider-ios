//
//  SRGILRubric.m
//  SRFPlayer
//
//  Created by Samuel Défago on 12/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
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
