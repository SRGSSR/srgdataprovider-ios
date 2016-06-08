//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
        _programEpisodeURI = dictionary[@"programmEpisodeUri"];
        
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });        
        _startTime = [dateFormatter dateFromString:dictionary[@"startTime"]];
        _endTime = [dateFormatter dateFromString:dictionary[@"endTime"]];
        
        SRGILImage *image = [[SRGILImage alloc] initWithDictionary:dictionary[@"Image"]];
        _imageURL = [[image imageRepresentationForUsage:SRGILMediaImageUsageWeb] URL];
    }
    return self;
}

@end
