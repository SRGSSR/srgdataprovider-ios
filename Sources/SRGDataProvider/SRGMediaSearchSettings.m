//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaSearchSettings.h"

#import "SRGDay+Private.h"

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
                         @(SRGQualityHQ) : @"hd" /* Same value as for HD */ };
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

static NSString *SRGBoolParameter(BOOL boolean)
{
    return boolean ? @"true" : @"false";
}

@implementation SRGMediaSearchSettings

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.aggregationsEnabled = YES;
        self.suggestionsEnabled = NO;
    }
    return self;
}

#pragma mark Getters and setters

- (NSSet<NSString *> *)showURNs
{
    return _showURNs ?: NSSet.set;
}

- (NSSet<NSString *> *)topicURNs
{
    return _topicURNs ?: NSSet.set;
}

- (NSArray<NSURLQueryItem *> *)queryItems
{
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"includeAggregations" value:SRGBoolParameter(self.aggregationsEnabled)]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"includeSuggestions" value:SRGBoolParameter(self.suggestionsEnabled)]];

    if ((self.matchingOptions & SRGSearchMatchingOptionAny) != 0) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"operator" value:@"or"]];
    }
    
    if ((self.matchingOptions & SRGSearchMatchingOptionExact) != 0) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"enableFuzzySearch" value:@"false"]];
    }
    
    if (self.showURNs.count != 0) {
        NSArray<NSString *> *showURNs = [self.showURNs sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES] ]];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"showUrns" value:[showURNs componentsJoinedByString:@","]]];
    }
    if (self.topicURNs.count != 0) {
        NSArray<NSString *> *topicURNs = [self.topicURNs sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES] ]];
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"topicUrns" value:[topicURNs componentsJoinedByString:@","]]];
    }
    
    NSString *mediaType = SRGMediaTypeParameter(self.mediaType);
    if (mediaType) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"mediaType" value:mediaType]];
    }
    
    if (self.subtitlesAvailable) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"subtitlesAvailable" value:SRGBoolParameter(self.subtitlesAvailable.boolValue)]];
    }
    if (self.downloadAvailable) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"downloadAvailable" value:SRGBoolParameter(self.downloadAvailable.boolValue)]];
    }
    if (self.playableAbroad) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"playableAbroad" value:SRGBoolParameter(self.playableAbroad.boolValue)]];
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
    
    SRGDay *fromDay = self.fromDay;
    if (fromDay) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publishedDateFrom" value:fromDay.string]];
    }
    
    SRGDay *toDay = self.toDay;
    if (toDay) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"publishedDateTo" value:toDay.string]];
    }
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sortBy" value:SRGSortCriteriumParameter(self.sortCriterium)]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sortDir" value:SRGSortDirectionParameter(self.sortDirection)]];
        
    return queryItems.copy;
}

@end
