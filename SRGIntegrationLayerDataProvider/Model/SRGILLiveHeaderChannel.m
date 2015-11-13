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
        if ([nowAndNext isKindOfClass:[NSDictionary class]]) {
            if ([[nowAndNext allKeys] containsObject:@"Now"]) {
                self.now = [[SRGILLiveHeaderData alloc] initWithDictionary:nowAndNext[@"Now"]];
            }
            if ([[nowAndNext allKeys] containsObject:@"Next"]) {
                self.next = [[SRGILLiveHeaderData alloc] initWithDictionary:nowAndNext[@"Next"]];
            }
        }
    }
    return self;
}

@end
