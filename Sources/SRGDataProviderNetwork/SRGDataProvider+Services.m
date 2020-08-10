//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+Services.h"

#import "SRGDataProvider+Network.h"

// Keys for access to parsed response information
// TODO: Share these keys
static NSString * const SRGParsedObjectKey = @"object";
static NSString * const SRGParsedNextURLKey = @"nextURL";
static NSString * const SRGParsedTotalKey = @"total";
static NSString * const SRGParsedMediaAggregationsKey = @"mediaAggregations";
static NSString * const SRGParsedSearchSuggestionsKey = @"searchSuggestions";

@import libextobjc;

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

@implementation SRGDataProvider (TVServices)

- (SRGRequest *)tvChannelsForVendor:(SRGVendor)vendor
                withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/tv", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGChannel.class rootKey:@"channelList" completionBlock:completionBlock];
}

- (SRGRequest *)tvChannelForVendor:(SRGVendor)vendor
                           withUid:(NSString *)channelUid
                   completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channel/%@/tv/nowAndNext", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGChannel.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(NSString *)livestreamUid
                                          fromDate:(NSDate *)fromDate
                                            toDate:(NSDate *)toDate
                               withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        return [MTLJSONAdapter modelOfClass:SRGProgramComposition.class fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id _Nullable object, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvLivestreamsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/livestreams", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvScheduledLivestreamsForVendor:(SRGVendor)vendor
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvEditorialMediasForVendor:(SRGVendor)vendor
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/editorial", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestMediasForVendor:(SRGVendor)vendor
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestEpisodes", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvMostPopularMediasForVendor:(SRGVendor)vendor
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/mostClicked", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvSoonExpiringMediasForVendor:(SRGVendor)vendor
                                   withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/soonExpiring", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor withLimit:(NSNumber *)limit completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self tvTrendingMediasForVendor:vendor withLimit:limit editorialLimit:nil episodesOnly:NO completionBlock:completionBlock];
}

- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor withLimit:(NSNumber *)limit editorialLimit:(NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGMediaListCompletionBlock)completionBlock
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvLatestEpisodesForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestEpisodes", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvEpisodesForVendor:(SRGVendor)vendor
                                         day:(SRGDay *)day
                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (! day) {
        day = SRGDay.today;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/episodesByDate/%@", SRGPathComponentForVendor(vendor), day.string];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvTopicsForVendor:(SRGVendor)vendor
              withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGTopic.class rootKey:@"topicList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                      withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/tv/alphabetical", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query
                      withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultShowList/tv", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultShowList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], page, nextPage, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (RadioServices)

- (SRGRequest *)radioChannelsForVendor:(SRGVendor)vendor withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/radio", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGChannel.class rootKey:@"channelList" completionBlock:completionBlock];
}

- (SRGRequest *)radioChannelForVendor:(SRGVendor)vendor
                              withUid:(NSString *)channelUid
                        livestreamUid:(NSString *)livestreamUid
                      completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channel/%@/radio/nowAndNext", SRGPathComponentForVendor(vendor), channelUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (livestreamUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid] ];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGChannel.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioLatestProgramsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                        livestreamUid:(NSString *)livestreamUid
                                             fromDate:(NSDate *)fromDate
                                               toDate:(NSDate *)toDate
                                  withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        return [MTLJSONAdapter modelOfClass:SRGProgramComposition.class fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id _Nullable object, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/livestreamsByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                         contentProviders:(SRGContentProviders)contentProviders
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/latestByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/mostClickedByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/latestEpisodesByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioEpisodesForVendor:(SRGVendor)vendor
                                            day:(SRGDay *)day
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (! day) {
        day = SRGDay.today;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/episodesByDateAndChannel/%@/%@", SRGPathComponentForVendor(vendor), day.string, channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioTopicsForVendor:(SRGVendor)vendor
                 withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/radio", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGTopic.class rootKey:@"topicList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/radio/alphabeticalByChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
                         withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultShowList/radio", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultShowList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/songList/radio/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSong.class rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioCurrentSongForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGSongCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/songList/radio/byChannel/%@", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:@[ [NSURLQueryItem queryItemWithName:@"onlyCurrentSong" value:@"true"] ]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSong.class rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects.firstObject, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (LiveCenterServices)


- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams/livecenter", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (SearchServices)

- (SRGFirstPageRequest *)mediasForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                            withSettings:(SRGMediaSearchSettings *)settings
                         completionBlock:(SRGPaginatedMediaSearchCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultMediaList", SRGPathComponentForVendor(vendor)];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (query) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"q" value:query]];
    }
    
    if (settings) {
        [queryItems addObjectsFromArray:settings.queryItems];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultMediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], metadata[SRGParsedMediaAggregationsKey], metadata[SRGParsedSearchSuggestionsKey], page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)showsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType
                    withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultShowList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)mostSearchedShowsForVendor:(SRGVendor)vendor withCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/mostClickedSearchResults", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
                         completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (RecommendationServices)

- (SRGFirstPageRequest *)recommendedMediasForURN:(NSString *)URN
                                          userId:(NSString *)userId
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (userId) {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommendedByUserId/byUrn/%@/%@", URN, userId];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommended/byUrn/%@", URN];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (ModuleServices)

- (SRGRequest *)modulesForVendor:(SRGVendor)vendor
                            type:(SRGModuleType)moduleType
             withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock
{
    NSString *moduleTypeString = [SRGModuleTypeJSONTransformer() reverseTransformedValue:@(moduleType)];
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/moduleConfigList/%@", SRGPathComponentForVendor(vendor), moduleTypeString.lowercaseString];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGModule.class rootKey:@"moduleConfigList" completionBlock:completionBlock];
}

@end

@implementation SRGDataProvider (GeneralServices)

- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/general/information", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGServiceMessage.class completionBlock:completionBlock];
}

@end

@implementation SRGDataProvider (PopularityServices)

- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                                       URN:(NSString *)URN
                                     event:(NSString *)event
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock
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
    
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGSocialCountOverview.class completionBlock:completionBlock];
}

- (SRGRequest *)increaseSearchResultsViewCountForShow:(SRGShow *)show
                                  withCompletionBlock:(SRGShowStatisticsOverviewCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showStatistic/byUrn/%@/searchResultClicked", show.URN];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShowStatisticsOverview.class completionBlock:completionBlock];
}

@end

@implementation SRGDataProvider (URNServices)

- (SRGRequest *)mediaWithURN:(NSString *)mediaURN completionBlock:(SRGMediaCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/media/byUrn/%@", mediaURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGMedia.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)mediasWithURNs:(NSArray<NSString *> *)mediaURNs completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/byUrns"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[mediaURNs componentsJoinedByString: @","]] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latest/byTopicUrn/%@", topicURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)mostPopularMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/mostClicked/byTopicUrn/%@", topicURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)mediaCompositionForURN:(NSString *)mediaURN standalone:(BOOL)standalone withCompletionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.1/mediaComposition/byUrn/%@", mediaURN];
    NSArray<NSURLQueryItem *> *queryItems = standalone ? @[ [NSURLQueryItem queryItemWithName:@"onlyChapters" value:@"true"] ] : nil;
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGMediaComposition.class completionBlock:completionBlock];
}

- (SRGRequest *)showWithURN:(NSString *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/show/byUrn/%@", showURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShow.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)showsWithURNs:(NSArray<NSString *> *)showURNs completionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showList/byUrns"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[showURNs componentsJoinedByString: @","]] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(NSString *)showURN maximumPublicationDay:(SRGDay *)maximumPublicationDay completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/episodeComposition/latestByShow/byUrn/%@", showURN];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (maximumPublicationDay) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxPublishedDate" value:maximumPublicationDay.string]];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        return [MTLJSONAdapter modelOfClass:SRGEpisodeComposition.class fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id _Nullable object, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForModuleWithURN:(NSString *)moduleURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latestByModuleConfigUrn/%@", moduleURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

@end
