//
//  SRGILSearchResult.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Frédéric VERGEZ on 29/07/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILSearchResult.h"

@implementation SRGILSearchResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });
        
        _title = dictionary[@"title"];
        _resultDescription = dictionary[@"description"];
        _publishedDate = [dateFormatter dateFromString:dictionary[@"publishedDate"]];
        _imageURL = [NSURL URLWithString:dictionary[@"imageurl"]];
        _duration = [dictionary[@"duration"] integerValue];
                
        [[dictionary valueForKeyPath:@"parentIds.id"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([@"assetgroup" isEqualToString:obj[@"@ref"]]) {
                _assetGroupId = obj[@"text"];
            }
            if ([@"assetset" isEqualToString:obj[@"@ref"]]) {
                _assetSetId = obj[@"text"];
            }
        }];
        
        [[dictionary valueForKeyPath:@"parentTitles.title"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([@"assetgroup" isEqualToString:obj[@"@ref"]]) {
                _assetGroupTitle = obj[@"text"];
            }
            if ([@"assetset" isEqualToString:obj[@"@ref"]]) {
                _assetSetTitle = obj[@"text"];
            }
        }];
    }
    
    return self;
}

@end
