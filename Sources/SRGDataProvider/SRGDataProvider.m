//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import "NSBundle+SRGDataProvider.h"
#import "SRGDataProviderLogger.h"
#import "SRGDay+Private.h"
#import "SRGJSONTransformers.h"
#import "SRGMediaSearchSettings+Private.h"
#import "SRGSearchResult.h"
#import "SRGSessionDelegate.h"

@import libextobjc;
@import Mantle;

static SRGDataProvider *s_currentDataProvider;

// Keys for access to parsed response information
static NSString * const SRGParsedObjectKey = @"object";
static NSString * const SRGParsedNextURLKey = @"nextURL";
static NSString * const SRGParsedTotalKey = @"total";
static NSString * const SRGParsedMediaAggregationsKey = @"mediaAggregations";
static NSString * const SRGParsedSearchSuggestionsKey = @"searchSuggestions";

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
                              @(SRGVendorSWI) : @"swi",
                              @(SRGVendorSSATR) : @"ssatr" };
    });
    return s_pathComponents[@(vendor)] ?: @"not_supported";
}

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

// Attempt to split a request with a urns query parameter, returning the request for the URNs for the specified page.
// Returns `nil` if the request cannot be split. The original request is cloned to preserve its headers, most notably.
+ (NSURLRequest *)URLRequestForURNsPageWithSize:(NSUInteger)size number:(NSUInteger)number URLRequest:(NSURLRequest *)URLRequest
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URLRequest.URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryItems = URLComponents.queryItems.mutableCopy ?: [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(NSURLQueryItem.new, name), @"urns"];
    NSURLQueryItem *URNsQueryItem = [URLComponents.queryItems filteredArrayUsingPredicate:predicate].firstObject;
    
    if (! URNsQueryItem.value) {
        return nil;
    }
    
    static NSString * const kURNsSeparator = @",";
    NSArray<NSString *> *URNs = [URNsQueryItem.value componentsSeparatedByString:kURNsSeparator];
    if (number == 0 && URNs.count < 2) {
        return URLRequest;
    }
    
    NSUInteger location = number * size;
    if (location >= URNs.count) {
        return nil;
    }
    
    NSRange range = NSMakeRange(location, MIN(size, URNs.count - location));
    NSArray<NSString *> *pageURNs = [URNs subarrayWithRange:range];
    NSURLQueryItem *pageURNsQueryItem = [NSURLQueryItem queryItemWithName:@"urns" value:[pageURNs componentsJoinedByString:kURNsSeparator]];
    [queryItems replaceObjectAtIndex:[queryItems indexOfObject:URNsQueryItem] withObject:pageURNsQueryItem];
    
    URLComponents.queryItems = queryItems.copy;
    
    NSMutableURLRequest *URNsURLRequest = URLRequest.mutableCopy;
    URNsURLRequest.URL = URLComponents.URL;
    return URNsURLRequest.copy;              // Not an immutable copy ;(
}

#pragma mark Object lifecycle

- (instancetype)initWithServiceURL:(NSURL *)serviceURL
{
    NSAssert(! serviceURL.fileURL, @"File URLs are not supported");
    
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

#pragma mark Radio services

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

#pragma mark Song services

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

#pragma mark Live center services

- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams/livecenter", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

#pragma mark Search services

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

#pragma mark Recommendation services

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

#pragma mark Module services

- (SRGRequest *)modulesForVendor:(SRGVendor)vendor
                            type:(SRGModuleType)moduleType
             withCompletionBlock:(SRGModuleListCompletionBlock)completionBlock
{
    NSString *moduleTypeString = [SRGModuleTypeJSONTransformer() reverseTransformedValue:@(moduleType)];
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/moduleConfigList/%@", SRGPathComponentForVendor(vendor), moduleTypeString.lowercaseString];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGModule.class rootKey:@"moduleConfigList" completionBlock:completionBlock];
}

#pragma mark General services

- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/general/information", SRGPathComponentForVendor(vendor)];
    NSURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGServiceMessage.class completionBlock:completionBlock];
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
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaStatistic/byUrn/%@/%@", subdivision.URN, endpoint];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyJSONDictionary = subdivision.event ? @{ @"eventData" : subdivision.event } : @{};
    URLRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyJSONDictionary options:0 error:NULL];
    
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGSocialCountOverview.class completionBlock:completionBlock];
}

- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                          mediaComposition:(SRGMediaComposition *)mediaComposition
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock
{
    return [self increaseSocialCountForType:type subdivision:mediaComposition.mainSegment ?: mediaComposition.mainChapter withCompletionBlock:completionBlock];
}

- (SRGRequest *)increaseSearchResultsViewCountForShow:(SRGShow *)show
                                  withCompletionBlock:(SRGShowStatisticsOverviewCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showStatistic/byUrn/%@/searchResultClicked", show.URN];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShowStatisticsOverview.class completionBlock:completionBlock];
}

#pragma mark URN services

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

#pragma mark Common implementation

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

- (SRGRequest *)fetchObjectWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                          completionBlock:(void (^)(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [SRGRequest objectRequestWithURLRequest:URLRequest session:self.session parser:^id _Nullable(NSData *data, NSError * _Nullable __autoreleasing * _Nullable pError) {
        NSDictionary *JSONDictionary = SRGNetworkJSONDictionaryParser(data, pError);
        if (! JSONDictionary) {
            return nil;
        }
        
        return [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id  _Nullable object, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *HTTPResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        completionBlock(object, HTTPResponse, error);
    }];
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
    
    return [SRGRequest objectRequestWithURLRequest:URLRequest session:self.session parser:^id _Nullable(NSData * _Nonnull data, NSError * _Nullable __autoreleasing * _Nullable pError) {
        NSDictionary *JSONDictionary = SRGNetworkJSONDictionaryParser(data, pError);
        if (! JSONDictionary) {
            return nil;
        }
        
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
            return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:pError];
        }
        else {
            // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array.
            // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
            return @[];
        }
    } completionBlock:^(id  _Nullable object, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *HTTPResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        completionBlock(object, HTTPResponse, error);
    }];
}

// Helper for common paginated request implementation. Extract common values from the JSON dictionary of IL responses,
// while letting the parser still be customised.
- (SRGFirstPageRequest *)pageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                            parser:(id (^)(NSDictionary *JSONDictionary, NSError * __autoreleasing *pError))parser
                                   completionBlock:(void (^)(id _Nullable object, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(parser);
    NSParameterAssert(completionBlock);
    
    return [[SRGFirstPageRequest objectRequestWithURLRequest:URLRequest session:self.session parser:^id _Nullable(NSData * _Nonnull data, NSError * _Nullable __autoreleasing * _Nullable pError) {
        // Extract object and standard top-level information if available
        NSMutableDictionary<NSString *, id> *parsedObjectDictionary = [NSMutableDictionary dictionary];
        
        NSDictionary *JSONDictionary = SRGNetworkJSONDictionaryParser(data, pError);
        if (*pError) {
            return nil;
        }
        
        parsedObjectDictionary[SRGParsedObjectKey] = JSONDictionary ? parser(JSONDictionary, pError) : nil;
        if (*pError) {
            return nil;
        }
        
        NSDictionary *aggregationsDictionary = JSONDictionary[@"aggregations"];
        if (aggregationsDictionary) {
            parsedObjectDictionary[SRGParsedMediaAggregationsKey] = [MTLJSONAdapter modelOfClass:SRGMediaAggregations.class fromJSONDictionary:aggregationsDictionary error:pError];
            if (*pError) {
                return nil;
            }
        }
        
        NSArray *suggestionsArray = JSONDictionary[@"suggestionList"];
        if (suggestionsArray) {
            parsedObjectDictionary[SRGParsedSearchSuggestionsKey] = [MTLJSONAdapter modelsOfClass:SRGSearchSuggestion.class fromJSONArray:suggestionsArray error:pError];
            if (*pError) {
                return nil;
            }
        }
        
        parsedObjectDictionary[SRGParsedNextURLKey] = [NSURL URLWithString:JSONDictionary[@"next"]];
        parsedObjectDictionary[SRGParsedTotalKey] = JSONDictionary[@"total"];
        
        return parsedObjectDictionary.copy;
    } sizer:^NSURLRequest *(NSURLRequest * _Nonnull URLRequest, NSUInteger size) {
        NSURLRequest *URNsRequest = [SRGDataProvider URLRequestForURNsPageWithSize:size number:0 URLRequest:URLRequest];
        if (URNsRequest) {
            return URNsRequest;
        }
        
        if (size > SRGDataProviderMaximumPageSize && size != SRGDataProviderUnlimitedPageSize) {
            size = SRGDataProviderMaximumPageSize;
        }
        
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URLRequest.URL resolvingAgainstBaseURL:NO];
        NSMutableArray<NSURLQueryItem *> *queryItems = URLComponents.queryItems.mutableCopy ?: [NSMutableArray array];
        NSString *pageSize = (size != SRGDataProviderUnlimitedPageSize) ? @(size).stringValue : @"unlimited";
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:pageSize]];
        URLComponents.queryItems = queryItems.copy;
        
        NSMutableURLRequest *sizedURLRequest = URLRequest.mutableCopy;
        sizedURLRequest.URL = URLComponents.URL;
        return sizedURLRequest.copy;              // Not an immutable copy ;(
    } paginator:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull URLRequest, NSDictionary<NSString *, id> * _Nullable parsedObjectDictionary, NSURLResponse * _Nullable response, NSUInteger size, NSUInteger number) {
        NSURLRequest *URNsRequest = [SRGDataProvider URLRequestForURNsPageWithSize:size number:number URLRequest:URLRequest];
        if (URNsRequest) {
            return URNsRequest;
        }
        
        NSURL *nextURL = parsedObjectDictionary[SRGParsedNextURLKey];
        if (nextURL) {
            NSMutableURLRequest *pageURLRequest = URLRequest.mutableCopy;
            pageURLRequest.URL = nextURL;
            return pageURLRequest.copy;              // Not an immutable copy ;(
        }
        else {
            return nil;
        }
    } completionBlock:^(NSDictionary<NSString *, id> * _Nullable parsedObjectDictionary, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *HTTPResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        
        id object = parsedObjectDictionary[SRGParsedObjectKey];
        NSDictionary<NSString *, id> *metadata = [parsedObjectDictionary mtl_dictionaryByRemovingValuesForKeys:@[ SRGParsedObjectKey ]];
        completionBlock(object, metadata, page, nextPage, HTTPResponse, error);
    }] requestWithPageSize:SRGDataProviderDefaultPageSize];
}

- (SRGFirstPageRequest *)listPaginatedObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                                 modelClass:(Class)modelClass
                                                    rootKey:(NSString *)rootKey
                                            completionBlock:(void (^)(NSArray * _Nullable objects, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(URLRequest);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
            return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:pError];
        }
        else {
            // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array.
            // See https://srfmmz.atlassian.net/wiki/display/SRGPLAY/Developer+Meeting+2016-10-05
            return @[];
        }
    } completionBlock:completionBlock];
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
    return @MARKETING_VERSION;
}
