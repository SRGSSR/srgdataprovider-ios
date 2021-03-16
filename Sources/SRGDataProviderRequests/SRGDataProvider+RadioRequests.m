//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+RadioRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

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
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (livestreamUid) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid]];
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
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    switch (contentProviders) {
        case SRGContentProvidersAll: {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"includeThirdPartyStreams" value:@"true"]];
            break;
        }
            
        case SRGContentProvidersSwissSatelliteRadio: {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"onlyThirdPartyContentProvider" value:@"ssatr"]];
            break;
        }
            
        default: {
            break;
        }
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
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
