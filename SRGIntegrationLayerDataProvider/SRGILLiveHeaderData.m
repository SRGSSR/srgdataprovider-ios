//
//  SRGILLiveHeaderData.m
//  SRGMediaPlayer
//
//  Created by Cédric Foellmi on 03/12/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import "SRGILLiveHeaderData.h"
#import "SRGILImage.h"
#import "SRGILImageRepresentation.h"

@implementation SRGILLiveHeaderData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _contentReceptionDate = [NSDate date];
        _title = [dictionary[@"title"] length] ? dictionary[@"title"] : nil;
        _subtitle = [dictionary[@"subTitle"] length] ? dictionary[@"subTitle"] : nil;
        #if DEBUG_LIVE_HEADER_DATA
        _title = @"now and next title. This may take more than one line to be displayed, probably two, maybe more, let's see";
        _subtitle = @"now and next subtitle. This may take more than one line to be displayed, probably two, maybe more, let's see";
        #endif
        _programEpisodeURI = dictionary[@"programmEpisodeUri"];
        
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });        
        _startTime = [dateFormatter dateFromString:dictionary[@"startTime"]];
        
        SRGILImage *image = [[SRGILImage alloc] initWithDictionary:dictionary[@"Image"]];
        _imageURL = [[image imageRepresentationForUsage:SRGILMediaImageUsageWeb] URL];
    }
    return self;
}

@end
