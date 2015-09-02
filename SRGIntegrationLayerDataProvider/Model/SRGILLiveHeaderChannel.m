//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
