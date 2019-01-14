//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import "NSBundle+SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGDataProviderLogger.h"
#import "SRGJSONTransformers.h"
#import "SRGPage+Private.h"
#import "SRGFirstPageRequest+Private.h"
#import "SRGRequest+Private.h"
#import "SRGSessionDelegate.h"

#import <libextobjc/libextobjc.h>
#import <Mantle/Mantle.h>

static SRGDataProvider *s_currentDataProvider;

static NSString *SRGDataProviderRequestDateString(NSDate *date);
static NSURLQueryItem *SRGDataProviderURLQueryItemForMaximumPublicationMonth(NSDate *maximumPublicationMonth);

NSURL *SRGIntegrationLayerProductionServiceURL(void)
{
    return [NSURL URLWithString:@"https://il.srgssr.ch/integrationlayer"];
}

NSURL *SRGIntegrationLayerStagingServiceURL(void)
{
    return [NSURL URLWithString:@"https://il-stage.srgssr.ch/integrationlayer"];
}

NSURL *SRGIntegrationLayerTestServiceURL(void)
{
    return [NSURL URLWithString:@"https://il-test.srgssr.ch/integrationlayer"];
}

NSString *SRGPathComponentForVendor(SRGVendor vendor)
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_pathComponents;
    dispatch_once(&s_onceToken, ^{
        s_pathComponents = @{ @(SRGVendorRSI) : @"rsi",
                              @(SRGVendorRTR) : @"rtr",
                              @(SRGVendorRTS) : @"rts",
                              @(SRGVendorSRF) : @"srf",
                              @(SRGVendorSWI) : @"swi" };
    });
    return s_pathComponents[@(vendor)] ?: @"not_supported";
}

@interface SRGDataProvider ()

@property (nonatomic) NSURL *serviceURL;
@property (nonatomic) NSURLSession *session;

@end

@implementation SRGDataProvider

#pragma mark Class methods

+ (SRGDataProvider *)currentDataProvider
{
    return s_currentDataProvider;
}

+ (void)setCurrentDataProvider:(SRGDataProvider *)currentDataProvider
{
    s_currentDataProvider = currentDataProvider;
}

#pragma mark Object lifecycle

- (instancetype)initWithServiceURL:(NSURL *)serviceURL
{
    if (self = [super init]) {
        self.serviceURL = serviceURL;
        
        // The session delegate is retained. We could have self be the delegate, but we would need a way to invalidate
        // the session (e.g. by calling -invalidateAndCancel) so that the delegate is released, and thus a data provider
        // public invalidation method to be called for proper release. To avoid having this error-prone needs, we add
        // another object as delegate and use dealloc to invalidate the session
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        SRGSessionDelegate *sessionDelegate = [[SRGSessionDelegate alloc] init];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:sessionDelegate delegateQueue:nil];
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma clang diagnostic pop

- (void)dealloc
{
    [self.session invalidateAndCancel];
}

#pragma mark TV services

- (SRGRequest *)tvChannelsForVendor:(SRGVendor)vendor
                withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/tv.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGChannel.class rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvChannelForVendor:(SRGVendor)vendor
                           withUid:(NSString *)channelUid
                   completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channel/%@/tv/nowAndNext.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGChannel.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvLivestreamsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/livestreams.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvScheduledLivestreamsForVendor:(SRGVendor)vendor
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvEditorialMediasForVendor:(SRGVendor)vendor
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/editorial.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestMediasForVendor:(SRGVendor)vendor
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestEpisodes.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvMostPopularMediasForVendor:(SRGVendor)vendor
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/mostClicked.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvSoonExpiringMediasForVendor:(SRGVendor)vendor
                                   withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/soonExpiring.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor withLimit:(NSNumber *)limit completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self tvTrendingMediasForVendor:vendor withLimit:limit editorialLimit:nil episodesOnly:NO completionBlock:completionBlock];
}

- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor withLimit:(NSNumber *)limit editorialLimit:(NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/trending.json", SRGPathComponentForVendor(vendor)];
    
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
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestEpisodesForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestEpisodes.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvEpisodesForVendor:(SRGVendor)vendor
                                        date:(NSDate *)date
                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (! date) {
        date = NSDate.date;
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/episodesByDate/%@.json", SRGPathComponentForVendor(vendor), dateString];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvTopicsForVendor:(SRGVendor)vendor
              withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGTopic.class rootKey:@"topicList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                      withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/tv/alphabetical.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor matchingQuery:(NSString *)query withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultListShow/tv.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSearchResultShow.class rootKey:@"searchResultListShow" pageCompletionBlock:completionBlock];
}

#pragma mark Radio services

- (SRGRequest *)radioChannelsForVendor:(SRGVendor)vendor withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/radio.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGChannel.class rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioChannelForVendor:(SRGVendor)vendor
                              withUid:(NSString *)channelUid
                        livestreamUid:(NSString *)livestreamUid
                      completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channel/%@/radio/nowAndNext.json", SRGPathComponentForVendor(vendor), channelUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (livestreamUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid] ];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGChannel.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/livestreamsByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                         contentProviders:(SRGContentProviders)contentProviders
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/livestreams.json", SRGPathComponentForVendor(vendor)];
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
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/latestByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/mostClickedByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/latestEpisodesByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioEpisodesForVendor:(SRGVendor)vendor
                                           date:(NSDate *)date
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (! date) {
        date = NSDate.date;
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/audio/episodesByDateAndChannel/%@/%@.json", SRGPathComponentForVendor(vendor), dateString, channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/radio/alphabeticalByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
                         withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultListShow/radio.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSearchResultShow.class rootKey:@"searchResultListShow" pageCompletionBlock:completionBlock];
}

#pragma mark Song services

- (SRGFirstPageRequest *)radioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/songList/radio/byChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSong.class rootKey:@"songList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioCurrentSongForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGSongCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/songList/radio/byChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:@[ [NSURLQueryItem queryItemWithName:@"onlyCurrentSong" value:@"true"] ]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSong.class rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects.firstObject, HTTPResponse, error);
    }];
}

#pragma mark Live center services

- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams/livecenter.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

#pragma mark Media search services

- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                     withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultListMedia/video.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSearchResultMedia.class rootKey:@"searchResultListMedia" pageCompletionBlock:completionBlock];
}

- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
                         completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (fullLengthExcluded) {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTags/excludeFullLength.json", SRGPathComponentForVendor(vendor)];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTags.json", SRGPathComponentForVendor(vendor)];
    }
    
    NSString *includesString = [tags componentsJoinedByString:@","];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"includes" value:includesString] ];
    if (excludedTags) {
        NSString *excludesString = [tags componentsJoinedByString:@","];
        queryItems = [queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"excludes" value:excludesString]];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)audiosForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                     withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultListMedia/audio.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSearchResultMedia.class rootKey:@"searchResultListMedia" pageCompletionBlock:completionBlock];
}

#pragma mark Recommendation services

- (SRGFirstPageRequest *)recommendedMediasForURN:(NSString *)URN
                                          userId:(NSString *)userId
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (userId) {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommendedByUserId/byUrn/%@/%@.json", URN, userId];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommended/byUrn/%@.json", URN];
    }
    
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

#pragma mark Module services

- (SRGRequest *)modulesForVendor:(SRGVendor)vendor
                            type:(SRGModuleType)moduleType
             withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock
{
    NSString *moduleTypeString = [SRGModuleTypeJSONTransformer() reverseTransformedValue:@(moduleType)];
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/moduleConfigList/%@.json", SRGPathComponentForVendor(vendor), moduleTypeString.lowercaseString];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGModule.class rootKey:@"moduleConfigList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, HTTPResponse, error);
    }];
}

#pragma mark General services

- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/general/information.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGServiceMessage.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

#pragma mark Popularity services

- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                               subdivision:(SRGSubdivision *)subdivision
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock
{
    NSParameterAssert(subdivision);
    
    // Won't crash in release builds, but the request will most likely fail
    NSAssert(subdivision.event, @"Expect event information");
    
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
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaStatistic/byUrn/%@/%@.json", subdivision.URN, endpoint];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyJSONDictionary = subdivision.event ? @{ @"eventData" : subdivision.event } : @{};
    URLRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyJSONDictionary options:0 error:NULL];
    
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGSocialCountOverview.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                          mediaComposition:(SRGMediaComposition *)mediaComposition
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock
{
    return [self increaseSocialCountForType:type subdivision:mediaComposition.mainSegment ?: mediaComposition.mainChapter withCompletionBlock:completionBlock];
}

#pragma mark URN services

- (SRGRequest *)mediaWithURN:(NSString *)mediaURN completionBlock:(SRGMediaCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/media/byUrn/%@.json", mediaURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGMedia.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)mediasWithURNs:(NSArray<NSString *> *)mediaURNs completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/byUrns.json"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[mediaURNs componentsJoinedByString: @","]] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latest/byTopicUrn/%@.json", topicURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)mostPopularMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/mostClicked/byTopicUrn/%@.json", topicURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)mediaCompositionForURN:(NSString *)mediaURN standalone:(BOOL)standalone withCompletionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaComposition/byUrn/%@.json", mediaURN];
    NSArray<NSURLQueryItem *> *queryItems = standalone ? @[ [NSURLQueryItem queryItemWithName:@"onlyChapters" value:@"true"] ] : nil;
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGMediaComposition.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGRequest *)showWithURN:(NSString *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/show/byUrn/%@.json", showURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShow.class completionBlock:^(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)showsWithURNs:(NSArray<NSString *> *)showURNs completionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showList/byUrns.json"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[showURNs componentsJoinedByString: @","]] ];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(NSString *)showURN maximumPublicationMonth:(NSDate *)maximumPublicationMonth completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/episodeComposition/latestByShow/byUrn/%@.json", showURN];
    NSArray<NSURLQueryItem *> *queryItems = maximumPublicationMonth ? @[ SRGDataProviderURLQueryItemForMaximumPublicationMonth(maximumPublicationMonth) ] : nil;
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGEpisodeComposition.class pageCompletionBlock:completionBlock];
}

- (SRGFirstPageRequest *)latestMediasForModuleWithURN:(NSString *)moduleURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latestByModuleConfigUrn/%@.json", moduleURN];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" pageCompletionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

#pragma mark Common implementation

- (NSURL *)URLForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [self.serviceURL URLByAppendingPathComponent:resourcePath];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"vector" value:@"appplay"]];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    URLComponents.queryItems = [fullQueryItems copy];
    
    return URLComponents.URL;
}

- (NSURLRequest *)URLRequestForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self.globalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull headerField, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:headerField];
    }];
    return [request copy];
}

- (SRGRequest *)listObjectsWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                                  rootKey:(NSString *)rootKey
                          completionBlock:(void (^)(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [[SRGRequest alloc] initWithURLRequest:URLRequest session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, HTTPResponse, error);
            });
            return;
        }
        
        NSError *modelError = nil;
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:&modelError];
            if (! objects) {
                SRGDataProviderLogError(@"DataProvider", @"Could not build model object of %@. Reason: %@", modelClass, modelError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, HTTPResponse, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                           code:SRGDataProviderErrorCodeInvalidData
                                                                       userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", @"Error message returned when a server response data is incorrect.") }]);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(objects, HTTPResponse, nil);
            });
        }
        else {
            // This also correctly handles the special case where the number of results is a multiple of the page size. When retrieved,
            // the last link will return an empty dictionary. If total count information is available, the last link will contain it
            // as well.
            // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(@[], HTTPResponse, nil);
            });
        }
    }];
}

- (SRGFirstPageRequest *)listObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                        modelClass:(Class)modelClass
                                           rootKey:(NSString *)rootKey
                               pageCompletionBlock:(void (^)(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))pageCompletionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(pageCompletionBlock);
    
    return [[SRGFirstPageRequest alloc] initWithURLRequest:URLRequest session:self.session pageCompletionBlock:^(NSDictionary * _Nullable JSONDictionary, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                pageCompletionBlock(nil, nil, page, nil, HTTPResponse, error);
            });
            return;
        }
        
        void (^invalidDataCompletionBlock)(void) = ^{
            pageCompletionBlock(nil, nil, page, nil, HTTPResponse, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                                       code:SRGDataProviderErrorCodeInvalidData
                                                                                   userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", @"Error message returned when a server response data is incorrect.") }]);
        };
        
        // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array.
        // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
        NSError *modelError = nil;
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:&modelError];
            if (! objects) {
                SRGDataProviderLogError(@"DataProvider", @"Could not build model object of %@. Reason: %@", modelClass, modelError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    invalidDataCompletionBlock();
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                pageCompletionBlock(objects, total, page, nextPage, HTTPResponse, nil);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                invalidDataCompletionBlock();
            });
        }
    }];
}

- (SRGRequest *)fetchObjectWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                          completionBlock:(void (^)(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [[SRGRequest alloc] initWithURLRequest:URLRequest session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, HTTPResponse, error);
            });
            return;
        }
        
        NSError *modelError = nil;
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:&modelError];
        if (! object) {
            SRGDataProviderLogError(@"DataProvider", @"Could not build model object of %@. Reason: %@", modelClass, modelError);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, HTTPResponse, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                       code:SRGDataProviderErrorCodeInvalidData
                                                                   userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", @"Error message returned when a server response data is incorrect.") }]);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(object, HTTPResponse, nil);
        });
    }];
}

- (SRGFirstPageRequest *)fetchObjectWithURLRequest:(NSURLRequest *)URLRequest
                                        modelClass:(Class)modelClass
                               pageCompletionBlock:(void (^)(id _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))pageCompletionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(modelClass);
    NSParameterAssert(pageCompletionBlock);
    
    return [[SRGFirstPageRequest alloc] initWithURLRequest:URLRequest session:self.session pageCompletionBlock:^(NSDictionary * _Nullable JSONDictionary, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                pageCompletionBlock(nil, page, nil, HTTPResponse, error);
            });
            return;
        }
        
        NSError *modelError = nil;
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:&modelError];
        if (! object) {
            SRGDataProviderLogError(@"DataProvider", @"Could not build model object of %@. Reason: %@", modelClass, modelError);
            dispatch_async(dispatch_get_main_queue(), ^{
                pageCompletionBlock(nil, page, nil, HTTPResponse, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                                      code:SRGDataProviderErrorCodeInvalidData
                                                                                  userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", @"Error message returned when a server response data is incorrect.") }]);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            pageCompletionBlock(object, page, nextPage, HTTPResponse, nil);
        });
    }];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; serviceURL = %@>",
            self.class,
            self,
            self.serviceURL];
}

@end

#pragma mark Functions

NSString *SRGDataProviderMarketingVersion(void)
{
    return [NSBundle srg_dataProviderBundle].infoDictionary[@"CFBundleShortVersionString"];
}

static NSString *SRGDataProviderRequestDateString(NSDate *date)
{
    NSCParameterAssert(date);
    
    static NSDateFormatter *s_dateFormatter;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_dateFormatter = [[NSDateFormatter alloc] init];
        s_dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return [s_dateFormatter stringFromDate:date];
}

static NSURLQueryItem *SRGDataProviderURLQueryItemForMaximumPublicationMonth(NSDate *maximumPublicationMonth)
{
    NSCParameterAssert(maximumPublicationMonth);
    
    static NSDateFormatter *s_dateFormatter;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_dateFormatter = [[NSDateFormatter alloc] init];
        s_dateFormatter.dateFormat = @"yyyy-MM";
    });
    
    return [NSURLQueryItem queryItemWithName:@"maxPublishedDate" value:[s_dateFormatter stringFromDate:maximumPublicationMonth]];
}
