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
        NSMutableDictionary *tmpData = [NSMutableDictionary dictionary];
        
        if ([entries count] > 0) {
            [entries enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                [tmpData setObject:obj[@"@value"] forKey:obj[@"@key"]];
            }];
        }
        
        _extendedData = [NSDictionary dictionaryWithDictionary:tmpData];
    }
    
    return self;
}


@end
