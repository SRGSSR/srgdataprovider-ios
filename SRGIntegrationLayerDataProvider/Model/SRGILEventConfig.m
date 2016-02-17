//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILEventConfig.h"

#import "UIColor+SRGILDataProvider.h"

@implementation SRGILEventConfig

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ([super initWithDictionary:dictionary]) {
        _title = dictionary[@"title"];
        
        _backgroundColor = [UIColor srg_colorWithHexString:dictionary[@"bgColor"]];
        _textColor = [UIColor srg_colorWithHexString:dictionary[@"textColor"]];
        _linkColor = [UIColor srg_colorWithHexString:dictionary[@"linkColor"]];
        
        NSString *backgroundImageURLString = dictionary[@"bgImageUrl"];
        _backgroundImageURL = backgroundImageURLString ? [NSURL URLWithString:backgroundImageURLString]: nil;
        
        NSString *logoImageURLString = dictionary[@"logoImageUrl"];
        _logoImageURL = logoImageURLString ? [NSURL URLWithString:logoImageURLString] : nil;
    }
    return self;
}

@end
