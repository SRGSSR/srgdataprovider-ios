//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+Requests.h"

static NSString *SRGStringFromDate(NSDate *date)
{
    // IL parameters are interpreted in the IL timezone (expected to be Zurich). Convert to Zurich dates so that the
    // returned objects have dates which, when converted back to the local timezone, match the original date specified.
    static dispatch_once_t s_onceToken;
    static NSDateFormatter *s_dateFormatter;
    dispatch_once(&s_onceToken, ^{
        s_dateFormatter = [[NSDateFormatter alloc] init];
        [s_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [s_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Zurich"]];
        [s_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    });
    return [s_dateFormatter stringFromDate:date];
}

static NSString *SRGPathComponentForVendor(SRGVendor vendor)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_pathComponents;
    dispatch_once(&s_onceToken, ^{
        s_pathComponents = @{ @(SRGVendorRSI) : @"rsi",
                              @(SRGVendorRTR) : @"rtr",
                              @(SRGVendorRTS) : @"rts",
                              @(SRGVendorSRF) : @"srf",
                              @(SRGVendorSWI) : @"swi",
                              @(SRGVendorSSATR) : @"ssatr" };
    });
    return s_pathComponents[@(vendor)] ?: @"not_supported";
}

static NSString *SRGPathComponentForModuleType(SRGModuleType moduleType)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_pathComponents;
    dispatch_once(&s_onceToken, ^{
        s_pathComponents = @{ @(SRGModuleTypeEvent) : @"event" };
    });
    return s_pathComponents[@(moduleType)] ?: @"not_supported";
}

@implementation SRGDataProvider (RequestsPrivate)

- (NSURLRequest *)URLRequestForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [self.serviceURL URLByAppendingPathComponent:resourcePath];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    [self.globalParameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:name value:value]];
    }];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"vector" value:@"appplay"]];
    URLComponents.queryItems = fullQueryItems.copy;
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URLComponents.URL];
    [self.globalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull headerField, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [URLRequest setValue:value forHTTPHeaderField:headerField];
    }];
    return URLRequest.copy;              // Not an immutable copy ;(
}

@end

@implementation SRGDataProvider (TVRequests)

- (NSURLRequest *)requestTVChannelsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/tv", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVChannelForVendor:(SRGVendor)vendor
                                    withUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channel/%@/tv/nowAndNext", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(NSString *)livestreamUid
                                          fromDate:(NSDate *)fromDate
                                            toDate:(NSDate *)toDate
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/programListComposition/tv/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (livestreamUid) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid]];
    }
    if (fromDate) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"minEndTime" value:SRGStringFromDate(fromDate)]];
    }
    if (toDate) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxStartTime" value:SRGStringFromDate(toDate)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestTVLivestreamsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/livestreams", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVScheduledLivestreamsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVEditorialMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/editorial", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVLatestMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestEpisodes", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVMostPopularMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/mostClicked", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVSoonExpiringMediasForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/soonExpiring", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVTrendingMediasForVendor:(SRGVendor)vendor
                                         withLimit:(NSNumber *)limit
                                    editorialLimit:(NSNumber *)editorialLimit
                                      episodesOnly:(BOOL)episodesOnly
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/trending", SRGPathComponentForVendor(vendor)];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    // This request does not support pagination, but a maximum number of results, specified via a pageSize parameter.
    // The name is sadly misleading, see https://srfmmz.atlassian.net/browse/AIS-15970. Maximum page size is 50.
    if (limit) {
        limit = @(MIN(MAX(0, limit.integerValue), 50));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:limit.stringValue]];
    }
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue]];
    }
    if (episodesOnly) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"onlyEpisodes" value:@"true"]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestTVLatestEpisodesForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestEpisodes", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVEpisodesForVendor:(SRGVendor)vendor
                                         day:(SRGDay *)day
{
    if (! day) {
        day = SRGDay.today;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/episodesByDate/%@", SRGPathComponentForVendor(vendor), day.string];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVTopicsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVShowsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/tv/alphabetical", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestTVShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultShowList/tv", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end

@implementation SRGDataProvider (RadioRequests)

- (NSURLRequest *)requestRadioChannelsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/radio", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioChannelForVendor:(SRGVendor)vendor
                                       withUid:(NSString *)channelUid
                                 livestreamUid:(NSString *)livestreamUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channel/%@/radio/nowAndNext", SRGPathComponentForVendor(vendor), channelUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (livestreamUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid] ];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestRadioLatestProgramsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                        livestreamUid:(NSString *)livestreamUid
                                             fromDate:(NSDate *)fromDate
                                               toDate:(NSDate *)toDate
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/programListComposition/radio/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (livestreamUid) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid]];
    }
    if (fromDate) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"minEndTime" value:SRGStringFromDate(fromDate)]];
    }
    if (toDate) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxStartTime" value:SRGStringFromDate(toDate)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestRadioLivestreamsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/livestreamsByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioLivestreamsForVendor:(SRGVendor)vendor
                                  contentProviders:(SRGContentProviders)contentProviders
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/livestreams", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = nil;
    
    switch (contentProviders) {
        case SRGContentProvidersAll: {
            queryItems = @[ [NSURLQueryItem queryItemWithName:@"includeThirdPartyStreams" value:@"true" ] ];
            break;
        }
            
        case SRGContentProvidersSwissSatelliteRadio: {
            queryItems = @[ [NSURLQueryItem queryItemWithName:@"onlyThirdPartyContentProvider" value:@"ssatr" ] ];
            break;
        }
            
        default: {
            break;
        }
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestRadioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/latestByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/mostClickedByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/latestEpisodesByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioEpisodesForVendor:(SRGVendor)vendor
                                     channelUid:(NSString *)channelUid
                                            day:(SRGDay *)day
{
    if (! day) {
        day = SRGDay.today;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/episodesByDateAndChannel/%@/%@", SRGPathComponentForVendor(vendor), day.string, channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioTopicsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/radio", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/radio/alphabeticalByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultShowList/radio", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestRadioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/songList/radio/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestRadioCurrentSongForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/songList/radio/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:@[ [NSURLQueryItem queryItemWithName:@"onlyCurrentSong" value:@"true"] ]];
}

@end

@implementation SRGDataProvider (LiveCenterRequests)

- (NSURLRequest *)requestLiveCenterVideosForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams/livecenter", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end

@implementation SRGDataProvider (SearchRequests)

- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                            withSettings:(SRGMediaSearchSettings *)settings
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultMediaList", SRGPathComponentForVendor(vendor)];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (query) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"q" value:query]];
    }
    
    if (settings) {
        [queryItems addObjectsFromArray:settings.queryItems];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultShowList", SRGPathComponentForVendor(vendor)];
    
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_mediaTypes;
    dispatch_once(&s_onceToken, ^{
        s_mediaTypes = @{ @(SRGMediaTypeVideo) : @"video",
                          @(SRGMediaTypeAudio) : @"audio" };
    });
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray arrayWithObject:[NSURLQueryItem queryItemWithName:@"q" value:query]];
    NSString *mediaTypeParameter = s_mediaTypes[@(mediaType)];
    if (mediaTypeParameter) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"mediaType" value:mediaTypeParameter]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestMostSearchedShowsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/mostClickedSearchResults", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestVideosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
{
    NSString *resourcePath = nil;
    if (fullLengthExcluded) {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTags/excludeFullLength", SRGPathComponentForVendor(vendor)];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTags", SRGPathComponentForVendor(vendor)];
    }
    
    NSString *includesString = [tags componentsJoinedByString:@","];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"includes" value:includesString] ];
    if (excludedTags) {
        NSString *excludesString = [tags componentsJoinedByString:@","];
        queryItems = [queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"excludes" value:excludesString]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end

@implementation SRGDataProvider (RecommendationRequests)

- (NSURLRequest *)requestRecommendedMediasForURN:(NSString *)URN
                                          userId:(NSString *)userId
{
    NSString *resourcePath = nil;
    if (userId) {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommendedByUserId/byUrn/%@/%@", URN, userId];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommended/byUrn/%@", URN];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end

@implementation SRGDataProvider (ModuleRequests)

- (NSURLRequest *)requestModulesForVendor:(SRGVendor)vendor
                                     type:(SRGModuleType)moduleType
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/moduleConfigList/%@", SRGPathComponentForVendor(vendor), SRGPathComponentForModuleType(moduleType)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end

@implementation SRGDataProvider (GeneralRequests)

- (NSURLRequest *)requestServiceMessageForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/general/information", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end

@implementation SRGDataProvider (PopularityRequests)

- (NSURLRequest *)requestIncreaseSocialCountForType:(SRGSocialCountType)type
                                                URN:(NSString *)URN
                                              event:(NSString *)event
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_endpoints;
    dispatch_once(&s_onceToken, ^{
        s_endpoints = @{ @(SRGSocialCountTypeSRGView) : @"clicked",
                         @(SRGSocialCountTypeSRGLike) : @"liked",
                         @(SRGSocialCountTypeFacebookShare) : @"shared/facebook",
                         @(SRGSocialCountTypeTwitterShare) : @"shared/twitter",
                         @(SRGSocialCountTypeGooglePlusShare) : @"shared/google",
                         @(SRGSocialCountTypeWhatsAppShare) : @"shared/whatsapp" };
    });
    NSString *endpoint = s_endpoints[@(type)];
    NSAssert(endpoint, @"A supported social count type must be provided");
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaStatistic/byUrn/%@/%@", URN, endpoint];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    URLRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{ @"eventData" : event } options:0 error:NULL];
    return URLRequest.copy;
}

- (NSURLRequest *)requestIncreaseSearchResultsViewCountForShow:(SRGShow *)show
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showStatistic/byUrn/%@/searchResultClicked", show.URN];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    return URLRequest.copy;
}

@end

@implementation SRGDataProvider (URNRequests)

- (NSURLRequest *)requestMediaWithURN:(NSString *)mediaURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/media/byUrn/%@", mediaURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestMediasWithURNs:(NSArray<NSString *> *)mediaURNs
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/byUrns"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[mediaURNs componentsJoinedByString: @","]] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestLatestMediasForTopicWithURN:(NSString *)topicURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latest/byTopicUrn/%@", topicURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestMostPopularMediasForTopicWithURN:(NSString *)topicURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/mostClicked/byTopicUrn/%@", topicURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestMediaCompositionForURN:(NSString *)mediaURN
                                     standalone:(BOOL)standalone
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.1/mediaComposition/byUrn/%@", mediaURN];
    NSArray<NSURLQueryItem *> *queryItems = standalone ? @[ [NSURLQueryItem queryItemWithName:@"onlyChapters" value:@"true"] ] : nil;
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestShowWithURN:(NSString *)showURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/show/byUrn/%@", showURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestShowsWithURNs:(NSArray<NSString *> *)showURNs
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showList/byUrns"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[showURNs componentsJoinedByString: @","]] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestLatestEpisodesForShowWithURN:(NSString *)showURN
                                maximumPublicationDay:(SRGDay *)maximumPublicationDay
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/episodeComposition/latestByShow/byUrn/%@", showURN];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (maximumPublicationDay) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxPublishedDate" value:maximumPublicationDay.string]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestLatestMediasForModuleWithURN:(NSString *)moduleURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latestByModuleConfigUrn/%@", moduleURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
