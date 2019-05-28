//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSearchFilters.h"

#import "NSDateFormatter+SRGDataProvider.h"

static NSString *SRGMediaTypeParameter(SRGMediaType mediaType)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_mediaTypes;
    dispatch_once(&s_onceToken, ^{
        s_mediaTypes = @{ @(SRGMediaTypeVideo) : @"video",
                          @(SRGMediaTypeAudio) : @"audio" };
    });
    return s_mediaTypes[@(mediaType)];
}

static NSString *SRGQualityParameter(SRGQuality quality)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_qualities;
    dispatch_once(&s_onceToken, ^{
        s_qualities = @{ @(SRGQualitySD) : @"sd",
                         @(SRGQualityHD) : @"hd",
                         @(SRGQualityHQ) : @"hd" };
    });
    return s_qualities[@(quality)];
}

static NSString *SRGSortCriteriumParameter(SRGSortCriterium sortCriterium)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_sortCriteria;
    dispatch_once(&s_onceToken, ^{
        s_sortCriteria = @{ @(SRGSortCriteriumDefault) : @"default",
                            @(SRGSortCriteriumDate) : @"date" };
    });
    return s_sortCriteria[@(sortCriterium)];
}

static NSString *SRGSortDirectionParameter(SRGSortDirection sortDirection)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_sortDirections;
    dispatch_once(&s_onceToken, ^{
        s_sortDirections = @{ @(SRGSortDirectionDescending) : @"desc",
                              @(SRGSortDirectionAscending) : @"asc" };
    });
    return s_sortDirections[@(sortDirection)];
}

@implementation SRGMediaSearchFilters

- (NSArray<NSURLQueryItem *> *)queryItems
{
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    if (self.showURNs) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"showUrns" value:[self.showURNs componentsJoinedByString:@","]]];
    }
    if (self.topicURNs) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"topicUrns" value:[self.topicURNs componentsJoinedByString:@","]]];
    }
    
    NSString *mediaType = SRGMediaTypeParameter(self.mediaType);
    if (mediaType) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"mediaType" value:mediaType]];
    }
    
    if (self.subtitlesAvailable) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"subtitlesAvailable" value:self.subtitlesAvailable.boolValue ? @"true" : @"false"]];
    }
    if (self.downloadAvailable) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"downloadAvailable" value:self.downloadAvailable.boolValue ? @"true" : @"false"]];
    }
    if (self.playableAbroad) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"playableAbroad" value:self.playableAbroad.boolValue ? @"true" : @"false"]];
    }
    
    NSString *quality = SRGQualityParameter(self.quality);
    if (quality) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"quality" value:quality]];
    }
    
    if (self.minimumDurationInMinutes) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"durationFromInMinutes" value:self.minimumDurationInMinutes.stringValue]];
    }
    if (self.maximumDurationInMinutes) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"durationToInMinutes" value:self.maximumDurationInMinutes.stringValue]];
    }
    
    if (self.afterDate) {
        NSString *afterDateString = [NSDateFormatter.srgdataprovider_dayDateFormatter stringFromDate:self.afterDate];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publishedDateFrom" value:afterDateString]];
    }
    if (self.beforeDate) {
        NSString *beforeDateString = [NSDateFormatter.srgdataprovider_dayDateFormatter stringFromDate:self.beforeDate];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publishedDateTo" value:beforeDateString]];
    }
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sortBy" value:SRGSortCriteriumParameter(self.sortCriterium)]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sortDir" value:SRGSortDirectionParameter(self.sortDirection)]];
        
    return [queryItems copy];
}

@end
