//
//  SRGILMediaMetadata.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "RTSMediaMetadata.h"

@implementation RTSMediaMetadata

+ (NSString *)primaryKey
{
    return @"identifier";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"identifier": @"",
             @"title": @"",
             @"parentTitle": @"",
             @"mediaDescription": @"",
             @"imageURLString": @"",
             @"radioShortName": @"",
             @"publicationDate": [NSDate dateWithTimeIntervalSince1970:0],
             @"expirationDate": [NSDate dateWithTimeIntervalSince1970:0],
             @"favoriteChangeDate": [NSDate dateWithTimeIntervalSince1970:0],
             @"durationInMs": @(-1),
             @"viewCount": @(-1),
             @"isDownloadable": @(0),
             @"isFavorite": @(0)};
}

+ (RTSMediaMetadata *)mediaMetadataForContainer:(id<RTSMediaMetadataContainer>)container
{
    if (!container) {
        return nil;
    }
    
    RTSMediaMetadata *md = [[RTSMediaMetadata alloc] init];
    
    md.identifier = [container identifier];
    md.title = [container title];
    md.parentTitle = [container parentTitle];
    md.mediaDescription = [container mediaDescription];
    md.imageURLString = [container imageURLString];
    md.radioShortName = [container radioShortName];
    
    md.publicationDate = [container publicationDate];
    md.expirationDate = [container expirationDate];
    md.favoriteChangeDate = [container favoriteChangeDate];
    
    md.durationInMs = [container durationInMs];
    md.viewCount = [container viewCount];
    md.isDownloadable = [container isDownloadable];
    md.isFavorite = [container isFavorite];
    
    return md;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[RTSMediaMetadata defaultPropertyValues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:obj forKey:key];
        }];
    }
    return self;
}

- (BOOL)isValueEmptyForKey:(NSString *)key
{
    NSArray *propertyKeys = [[RTSMediaMetadata defaultPropertyValues] allKeys];
    if (![propertyKeys containsObject:key]) {
        return NO;
    }
    return [[self valueForKey:key] isEqual:[[RTSMediaMetadata defaultPropertyValues] objectForKey:key]];
}

@end
