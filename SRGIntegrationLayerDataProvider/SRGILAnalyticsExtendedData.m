//
//  SRGAnalyticsData.m
//  SRGMediaPlayer
//
//  Created by Frédéric VERGEZ on 20/03/15.
//  Copyright (c) 2015 SRG SSR. All rights reserved.
//

#import "SRGILAnalyticsExtendedData.h"

@implementation SRGILAnalyticsExtendedData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];

    if (self) {
        NSArray *entries = [dictionary objectForKey:@"Entry"];
        
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
