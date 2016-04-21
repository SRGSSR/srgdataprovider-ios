//
//  SRGILVideo2.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Pierre-Yves Bertholon on 18/04/16.
//  Copyright © 2016 SRG. All rights reserved.
//

#import "SRGILVideo2.h"

@interface SRGILVideo2 ()

@property (nonatomic, strong) NSString *urn;
@property (nonatomic, assign) SRGILAssetSubSetType type;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageTitle;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger episodeId;
@property (nonatomic, strong) NSString *episodeTitle;
@property (nonatomic, assign) NSInteger showId;
@property (nonatomic, strong) NSString *showTitle;

@end

@implementation SRGILVideo2

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    
    NSAssert([dictionary isKindOfClass:NSDictionary.class], @"Expected a dictionary, received a %@°", [dictionary class]);
    
    self = [super init];
    if (self) {
        self.urn = dictionary[@"urn"];
        self.type = SRGILAssetSubSetTypeForString(dictionary[@"type"]);
        self.title = dictionary[@"title"];
        self.imageTitle = dictionary[@"imageTitle"];
        self.imageUrl = [NSURL URLWithString:dictionary[@"imageUrl"]];
        self.duration = [dictionary[@"duration"] integerValue];
        self.episodeId = [dictionary[@"episodeId"] integerValue];
        self.episodeTitle = dictionary[@"episodeTitle"];
        self.showId = [dictionary[@"showID"] integerValue];
        self.showTitle = dictionary[@"showTitle"];
        
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });
        
        self.date = [dateFormatter dateFromString:(NSString *)[dictionary objectForKey:@"date"]];
    }
    return self;
}

- (BOOL)isLiveStream
{
    return self.type == SRGILAssetSubSetTypeLivestream || self.type == SRGILAssetSubSetTypeScheduledLivestream;
}

@end
