//
//  SRGILMediaMetadata.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "RTSMediaMetadata.h"

#define REALM_NONNULL_STRING(value) ((value == nil) ? @"" : (value))
#define REALM_NONNULL_DATE(value) ((value == nil) ? [NSDate dateWithTimeIntervalSince1970:0] : (value))

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
    
    md.identifier = REALM_NONNULL_STRING([container identifier]);
    md.title = REALM_NONNULL_STRING([container title]);
    md.parentTitle = REALM_NONNULL_STRING([container parentTitle]);
    md.mediaDescription = REALM_NONNULL_STRING([container mediaDescription]);
    md.imageURLString = REALM_NONNULL_STRING([container imageURLString]);
    md.radioShortName = REALM_NONNULL_STRING([container radioShortName]);
    
    md.publicationDate = REALM_NONNULL_DATE([container publicationDate]);
    md.expirationDate = REALM_NONNULL_DATE([container expirationDate]);
    md.favoriteChangeDate = REALM_NONNULL_DATE(nil);
    
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
