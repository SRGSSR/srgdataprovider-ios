//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILRelatedContent.h"

@interface SRGILRelatedContent ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *URL;

@end

@implementation SRGILRelatedContent

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary: dictionary]) {
        _title = dictionary[@"title"];
        _text = dictionary[@"description"];
        
        NSString *URLString = dictionary[@"url"];
        _URL = URLString ? [NSURL URLWithString:URLString] : nil;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; title: %@; text: %@; URL: %@>",
            [self class],
            self,
            self.title,
            self.text,
            self.URL];
}

@end
