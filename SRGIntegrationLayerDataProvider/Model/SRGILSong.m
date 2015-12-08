//
//  SRGILSong.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILSong.h"
#import "SRGILArtist.h"

@implementation SRGILSong

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _title = dictionary[@"title"];
        _artist = [[SRGILArtist alloc] initWithDictionary:dictionary[@"Artist"]];
        
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });
        
        _modifiedDate = [dateFormatter dateFromString:dictionary[@"modifiedDate"]];
        _createdDate = [dateFormatter dateFromString:dictionary[@"createdDate"]];
    }
    return self;
}

@end
