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

static NSString * const SRGTokenServiceURLString = @"https://tp.srgssr.ch/akahd/token";

static SRGDataProvider *s_currentDataProvider;

static NSString *SRGDataProviderRequestDateString(NSDate *date);
static NSURLQueryItem *SRGDataProviderURLQueryItemForMaximumPublicationMonth(NSDate *maximumPublicationMonth);

NSURL *SRGIntegrationLayerProductionServiceURL(void)
{
    return [NSURL URLWithString:@"https://il.srgssr.ch"];
}

NSURL *SRGIntegrationLayerStagingServiceURL(void)
{
    return [NSURL URLWithString:@"https://il-stage.srgssr.ch"];
}

NSURL *SRGIntegrationLayerTestServiceURL(void)
{
    return [NSURL URLWithString:@"https://il-test.srgssr.ch"];
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

+ (SRGDataProvider *)setCurrentDataProvider:(SRGDataProvider *)currentDataProvider
{
    SRGDataProvider *previousDataProvider = s_currentDataProvider;
    s_currentDataProvider = currentDataProvider;
    return previousDataProvider;
}

#pragma mark Object lifecycle

- (instancetype)initWithServiceURL:(NSURL *)serviceURL
{
    if (self = [super init]) {
        // According to the standard, the base URL must end with a slash or the last path component will be truncated
        // See http://stackoverflow.com/questions/16582350/nsurl-urlwithstringrelativetourl-is-clipping-relative-url
        if ([serviceURL.absoluteString hasSuffix:@"/"]) {
            self.serviceURL = serviceURL;
        }
        else {
            self.serviceURL = [NSURL URLWithString:[serviceURL.absoluteString stringByAppendingString:@"/"]];
        }
        
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
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/tv.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)tvChannelForVendor:(SRGVendor)vendor
                           withUid:(NSString *)channelUid
                   completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channel/%@/tv/nowAndNext.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:request modelClass:[SRGChannel class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)tvLivestreamsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/livestreams.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)tvScheduledLivestreamsForVendor:(SRGVendor)vendor
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/scheduledLivestreams.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvEditorialMediasForVendor:(SRGVendor)vendor
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/editorial.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestMediasForVendor:(SRGVendor)vendor
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvMostPopularMediasForVendor:(SRGVendor)vendor
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/mostClicked.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvSoonExpiringMediasForVendor:(SRGVendor)vendor
                                   withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/soonExpiring.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor withLimit:(NSNumber *)limit completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self tvTrendingMediasForVendor:vendor withLimit:limit editorialLimit:nil episodesOnly:NO completionBlock:completionBlock];
}

- (SRGRequest *)tvTrendingMediasForVendor:(SRGVendor)vendor withLimit:(NSNumber *)limit editorialLimit:(NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/trending.json", SRGPathComponentForVendor(vendor)];
    
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
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestEpisodesForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvEpisodesForVendor:(SRGVendor)vendor
                                        date:(NSDate *)date
                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/episodesByDate/%@.json", SRGPathComponentForVendor(vendor), dateString];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)tvTopicsForVendor:(SRGVendor)vendor
              withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/topicList/tv.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGTopic class] rootKey:@"topicList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)tvEditorialShowsForVendor:(SRGVendor)vendor
                                    firstCharacter:(NSString *)firstCharacter
                               withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/alphabetical.json", SRGPathComponentForVendor(vendor)];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (firstCharacter) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"characterFilter" value:firstCharacter] ];
    }
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:request modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                      withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/alphabetical/all.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor matchingQuery:(NSString *)query withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListShow/tv.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:request modelClass:[SRGSearchResultShow class] rootKey:@"searchResultListShow" completionBlock:completionBlock];
}

#pragma mark Radio services

- (SRGRequest *)radioChannelsForVendor:(SRGVendor)vendor withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/radio.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)radioChannelForVendor:(SRGVendor)vendor
                              withUid:(NSString *)channelUid
                        livestreamUid:(NSString *)livestreamUid
                      completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channel/%@/radio/nowAndNext.json", SRGPathComponentForVendor(vendor), channelUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (livestreamUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid] ];
    }
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self fetchObjectWithRequest:request modelClass:[SRGChannel class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/livestreamsByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                         contentProviders:(SRGContentProviders)contentProviders
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/livestreams.json", SRGPathComponentForVendor(vendor)];
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
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/latestByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/mostClickedByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/latestEpisodesByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioEpisodesForVendor:(SRGVendor)vendor
                                           date:(NSDate *)date
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/episodesByDateAndChannel/%@/%@.json", SRGPathComponentForVendor(vendor), dateString, channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioEditorialShowsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                       firstCharacter:(NSString *)firstCharacter
                                  withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/radio/alphabeticalByChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (firstCharacter) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"characterFilter" value:firstCharacter] ];
    }
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:request modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                         withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/radio/alphabetical/all.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
                         withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListShow/radio.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:request modelClass:[SRGSearchResultShow class] rootKey:@"searchResultListShow" completionBlock:completionBlock];
}

#pragma mark Song services

- (SRGFirstPageRequest *)radioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/songList/radio/byChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGSong class] rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)radioCurrentSongForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGSongCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/songList/radio/byChannel/%@.json", SRGPathComponentForVendor(vendor), channelUid];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:@[ [NSURLQueryItem queryItemWithName:@"onlyCurrentSong" value:@"true"] ]];
    return [self listObjectsWithRequest:request modelClass:[SRGSong class] rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects.firstObject, error);
    }];
}

#pragma mark Live center services

- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/scheduledLivestreams/livecenter.json", SRGPathComponentForVendor(vendor)];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

#pragma mark Media search services

- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                     withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListMedia/video.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:request modelClass:[SRGSearchResultMedia class] rootKey:@"searchResultListMedia" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
                         completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (fullLengthExcluded) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByTags/excludeFullLength.json", SRGPathComponentForVendor(vendor)];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByTags.json", SRGPathComponentForVendor(vendor)];
    }
    
    NSString *includesString = [tags componentsJoinedByString:@","];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"includes" value:includesString] ];
    if (excludedTags) {
        NSString *excludesString = [tags componentsJoinedByString:@","];
        queryItems = [queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"excludes" value:excludesString]];
    }
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)audiosForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                     withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListMedia/audio.json", SRGPathComponentForVendor(vendor)];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:request modelClass:[SRGSearchResultMedia class] rootKey:@"searchResultListMedia" completionBlock:completionBlock];
}

#pragma mark Recommendation services

- (SRGFirstPageRequest *)recommendedVideosForVendor:(SRGVendor)vendor
                                                uid:(NSString *)uid
                                             userId:(NSString *)userId
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (userId) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/recommendedByUserId/%@/%@.json", SRGPathComponentForVendor(vendor), uid, userId];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/recommended/%@.json", SRGPathComponentForVendor(vendor), uid];
    }
    
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)recommendedTvShowsForVendor:(SRGVendor)vendor
                                              userId:(NSString *)userId
                                 withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/byUserId/%@.json", SRGPathComponentForVendor(vendor), userId];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

#pragma mark Module services

- (SRGRequest *)modulesForVendor:(SRGVendor)vendor
                            type:(SRGModuleType)moduleType
             withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock
{
    NSString *moduleTypeString = [SRGModuleTypeJSONTransformer() reverseTransformedValue:@(moduleType)];
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/moduleConfigList/%@.json", SRGPathComponentForVendor(vendor), moduleTypeString.lowercaseString];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGModule class] rootKey:@"moduleConfigList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
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
    
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaStatistic/byUrn/%@/%@.json", subdivision.URN, endpoint];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyJSONDictionary = subdivision.event ? @{ @"eventData" : subdivision.event } : @{};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyJSONDictionary options:0 error:NULL];
    
    return [self fetchObjectWithRequest:request modelClass:[SRGSocialCountOverview class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
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
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/media/byUrn/%@.json", mediaURN];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:request modelClass:[SRGMedia class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)mediasWithURNs:(NSArray<NSString *> *)mediaURNs completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaList/byUrns.json"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[mediaURNs componentsJoinedByString: @","]] ];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaList/latest/byTopicUrn/%@.json", topicURN];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)mostPopularMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaList/mostClicked/byTopicUrn/%@.json", topicURN];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)mediaCompositionForURN:(NSString *)mediaURN standalone:(BOOL)standalone withCompletionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaComposition/byUrn/%@.json", mediaURN];
    NSArray<NSURLQueryItem *> *queryItems = standalone ? @[ [NSURLQueryItem queryItemWithName:@"onlyChapters" value:@"true"] ] : nil;
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self fetchObjectWithRequest:request modelClass:[SRGMediaComposition class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)showWithURN:(NSString *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/show/byUrn/%@.json", showURN];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:request modelClass:[SRGShow class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)showsWithURNs:(NSArray<NSString *> *)showURNs completionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/showList/byUrns.json"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[showURNs componentsJoinedByString: @","]] ];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:request modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(NSString *)showURN maximumPublicationMonth:(NSDate *)maximumPublicationMonth completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/episodeComposition/latestByShow/byUrn/%@.json", showURN];
    NSArray<NSURLQueryItem *> *queryItems = maximumPublicationMonth ? @[ SRGDataProviderURLQueryItemForMaximumPublicationMonth(maximumPublicationMonth) ] : nil;
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:queryItems];
    return [self fetchObjectWithRequest:request modelClass:[SRGEpisodeComposition class] completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)latestMediasForModuleWithURN:(NSString *)moduleURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaList/latestByModuleConfigUrn/%@.json", moduleURN];
    NSURLRequest *request = [self requestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:request modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

#pragma mark Tokenization services

+ (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock
{
    NSParameterAssert(URL);
    NSParameterAssert(completionBlock);
    
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSString *acl = [URLComponents.path.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"*"];
    
    NSURLComponents *tokenServiceURLComponents = [NSURLComponents componentsWithURL:[NSURL URLWithString:SRGTokenServiceURLString] resolvingAgainstBaseURL:NO];
    tokenServiceURLComponents.queryItems = @[ [NSURLQueryItem queryItemWithName:@"acl" value:acl] ];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:tokenServiceURLComponents.URL];
    return [[SRGRequest alloc] initWithRequest:request session:[NSURLSession sharedSession] completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        // FIXME: SRGRequest is a concrete class, but will be turned into an abstract class soon. Until then, there is no way to
        //        perform dummy requests when no tokenization is required (which can be decided a priori based on the host). Until
        //        we have a mechanism to perform dummy requests, and since we cannot return nil (this would break how requests are
        //        dealt with at higher levels), we still perform the token request, but discard the result
        NSURL *tokenizedURL = URL;
        if ([URL.host containsString:@"akamai"]) {
            NSString *token = nil;
            
            id tokenDictionary = JSONDictionary[@"token"];
            if ([tokenDictionary isKindOfClass:[NSDictionary class]]) {
                token = [tokenDictionary objectForKey:@"authparams"];
            }
            
            if (!token) {
                completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                         code:SRGDataProviderErrorCodeInvalidData
                                                     userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The stream could not be secured.", @"The error message when the secure token cannot be retrieved to play the media stream.") }]);
                return;
            }
            
            // Use components to properly extract the token as query items
            NSURLComponents *tokenURLComponents = [[NSURLComponents alloc] init];
            tokenURLComponents.query = token;
            
            // Build the tokenized URL, merging token components with existing ones
            NSURLComponents *tokenizedURLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
            
            NSMutableArray *queryItems = [tokenizedURLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
            if (tokenURLComponents.queryItems) {
                [queryItems addObjectsFromArray:tokenURLComponents.queryItems];
            }
            tokenizedURLComponents.queryItems = [queryItems copy];
            tokenizedURL = tokenizedURLComponents.URL;
        }
        completionBlock(tokenizedURL, nil);
    }];
}

#pragma mark Common implementation

- (NSURL *)URLForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [NSURL URLWithString:[resourcePath stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet]
                        relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"vector" value:@"appplay"]];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    URLComponents.queryItems = [fullQueryItems copy];
    
    return URLComponents.URL;
}

- (NSURLRequest *)requestForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self.globalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull headerField, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:headerField];
    }];
    return [request copy];
}

- (SRGFirstPageRequest *)listObjectsWithRequest:(NSURLRequest *)request
                                     modelClass:(Class)modelClass
                                        rootKey:(NSString *)rootKey
                                completionBlock:(void (^)(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [[SRGFirstPageRequest alloc] initWithRequest:request session:self.session pageCompletionBlock:^(NSDictionary * _Nullable JSONDictionary, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, nil, page, nil, error);
            return;
        }
        
        NSError *modelError = nil;
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:[NSArray class]]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:&modelError];
            if (! objects) {
                SRGDataProviderLogError(@"DataProvider", @"Could not build model object of %@. Reason: %@", modelClass, modelError);
                completionBlock(nil, nil, page, nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                         code:SRGDataProviderErrorCodeInvalidData
                                                                     userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
                return;
            }
            
            completionBlock(objects, total, page, nextPage, nil);
        }
        else {
            // This also correctly handles the special case where the number of results is a multiple of the page size. When retrieved,
            // the last link will return an empty dictionary. If total count information is available, the last link will contain it
            // as well.
            // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
            completionBlock(@[], total, page, nil, nil);
        }
    }];
}

- (SRGFirstPageRequest *)fetchObjectWithRequest:(NSURLRequest *)request
                                     modelClass:(Class)modelClass
                                completionBlock:(void (^)(id _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [[SRGFirstPageRequest alloc] initWithRequest:request session:self.session pageCompletionBlock:^(NSDictionary * _Nullable JSONDictionary, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, page, nil, error);
            return;
        }
        
        NSError *modelError = nil;
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:&modelError];
        if (!object) {
            SRGDataProviderLogError(@"DataProvider", @"Could not build model object of %@. Reason: %@", modelClass, modelError);
            
            completionBlock(nil, page, nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                                code:SRGDataProviderErrorCodeInvalidData
                                                            userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
            return;
        }
        
        completionBlock(object, page, nextPage, nil);
    }];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; serviceURL: %@>",
            [self class],
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
