//
//  SRGILLiveHeaderChannel.m
//  SRGMediaPlayer
//
//  Created by Cédric Foellmi on 03/12/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import "SRGILLiveHeaderChannel.h"

@implementation SRGILLiveHeaderChannel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        NSDictionary *nowAndNext = dictionary[@"NowAndNext"];
        self.now = [[SRGILLiveHeaderData alloc] initWithDictionary:nowAndNext[@"Now"]];
        self.next = [[SRGILLiveHeaderData alloc] initWithDictionary:nowAndNext[@"Next"]];
    }
    return self;
}

@end
