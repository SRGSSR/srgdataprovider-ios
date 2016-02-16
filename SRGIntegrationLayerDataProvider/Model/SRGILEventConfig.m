//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILEventConfig.h"

@implementation SRGILEventConfig

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ([super initWithDictionary:dictionary]) {
        _title = dictionary[@"title"];
        _backgroundColor = dictionary[@"bgColor"];
        
#if 0
        // TODO: Color from hex
        _textColor = dictionary[@"textColor"];
        _linkColor = dictionary[@"linkColor"];
#endif
        
        NSString *backgroundImageURLString = dictionary[@"bgImageUrl"];
        _backgroundImageURL = backgroundImageURLString ? [NSURL URLWithString:backgroundImageURLString]: nil;
        
        NSString *logoImageURLString = dictionary[@"logoImageUrl"];
        _logoImageURL = logoImageURLString ? [NSURL URLWithString:logoImageURLString] : nil;
    }
    return self;
}

@end
