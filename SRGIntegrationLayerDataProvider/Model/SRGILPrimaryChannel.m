//
//  SRGPrimaryChannel.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 12/03/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILPrimaryChannel.h"

@implementation SRGILPrimaryChannel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _distributor = [dictionary objectForKey:@"distributor"];
        _title = [dictionary objectForKey:@"title"];
        _image = [[SRGILImage alloc] initWithDictionary:[dictionary objectForKey:@"Image"]];
    }
    return self;
}

@end
