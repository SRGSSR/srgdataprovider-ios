//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
        _primaryChannelId = dictionary[@"primaryChannelId"];
        
        // The IL is broken by design. Chiote.
        
        id tmp = [dictionary valueForKeyPath:@"parentIds.id"];
        if ([tmp isKindOfClass:[NSDictionary class]]) {
            tmp = @[tmp];
        }
        for (NSDictionary *subtmp in tmp) {
            if ([@"assetgroup" isEqualToString:subtmp[@"@ref"]]) {
                _assetGroupId = subtmp[@"text"];
            }
            if ([@"assetset" isEqualToString:subtmp[@"@ref"]]) {
                _assetSetId = subtmp[@"text"];
            }
        }
        
        tmp = [dictionary valueForKeyPath:@"parentTitles.title"];
        if ([tmp isKindOfClass:[NSDictionary class]]) {
            tmp = @[tmp];
        }
        for (NSDictionary *subtmp in tmp) {
            if ([@"assetgroup" isEqualToString:subtmp[@"@ref"]]) {
                _assetGroupTitle = subtmp[@"text"];
            }
            if ([@"assetset" isEqualToString:subtmp[@"@ref"]]) {
                _assetSetTitle = subtmp[@"text"];
            }
        }
    }
    
    return self;
}

@end
