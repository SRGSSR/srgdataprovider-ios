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
    }
    
    return self;
}

@end
