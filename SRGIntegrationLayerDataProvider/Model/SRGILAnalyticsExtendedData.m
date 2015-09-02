//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILAnalyticsExtendedData.h"

@implementation SRGILAnalyticsExtendedData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];

    if (self) {
        id tmpEntries = [dictionary objectForKey:@"Entry"];
        NSArray *entries = ([tmpEntries isKindOfClass:[NSDictionary class]]) ? @[tmpEntries] : tmpEntries;
        
        if ([entries count] > 0) {
            [entries enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if ([@"srg_c1" isEqualToString:obj[@"@key"]]) {
                    _srgC1 = obj[@"@value"];
                }
                
                if ([@"srg_c2" isEqualToString:obj[@"@key"]]) {
                    _srgC2 = obj[@"@value"];
                }
                
                if ([@"srg_c3" isEqualToString:obj[@"@key"]]) {
                    _srgC3 = obj[@"@value"];
                }
            }];
        }
    }
    
    return self;
}


@end
