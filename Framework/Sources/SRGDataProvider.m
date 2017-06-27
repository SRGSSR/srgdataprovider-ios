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

SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRSI = @"rsi";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTR = @"rtr";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierRTS = @"rts";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSRF = @"srf";
SRGDataProviderBusinessUnitIdentifier const SRGDataProviderBusinessUnitIdentifierSWI = @"swi";

static NSString * const SRGTokenServiceURLString = @"https://tp.srgssr.ch/akahd/token";

static SRGDataProvider *s_currentDataProvider;

static NSString *SRGDataProviderRequestDateString(NSDate *date);

@interface SRGDataProvider ()

@property (nonatomic) NSURL *serviceURL;
@property (nonatomic, copy) NSString *businessUnitIdentifier;
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

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier
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
        
        self.businessUnitIdentifier = businessUnitIdentifier;
        
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

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
}

#pragma mark Public TV services

- (SRGRequest *)tvChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)tvChannelWithUid:(NSString *)channelUid completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channel/%@/tv/nowAndNext.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)tvLivestreamsWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/livestreams.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)tvEditorialMediasWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/editorial.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvSoonExpiringMediasWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/soonExpiring.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvTrendingMediasWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    return [self tvTrendingMediasWithEditorialLimit:nil episodesOnly:NO completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvTrendingMediasWithEditorialLimit:(NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/trending.json", self.businessUnitIdentifier];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue]];
    }
    if (episodesOnly) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"onlyEpisodes" value:@"true"]];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    SRGFirstPageRequest *request = [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
    request.maximumPageSize = 50;
    return request;
}

- (SRGFirstPageRequest *)tvLatestEpisodesWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvEpisodesForDate:(NSDate *)date withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/episodesByDate/%@.json", self.businessUnitIdentifier, dateString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)tvTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/topicList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGTopic class] rootKey:@"topicList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestMediasForTopicWithUid:(NSString *)topicUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (topicUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/latestEpisodes.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvMostPopularMediasForTopicWithUid:(NSString *)topicUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/mostClicked.json", self.businessUnitIdentifier];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (topicUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"topicId" value:topicUid] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsWithCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/tv/alphabetical.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)tvShowWithUid:(NSString *)showUid completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/show/tv/%@.json", self.businessUnitIdentifier, showUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestEpisodesForShowWithUid:(NSString *)showUid oldestMonth:(NSDate *)oldestMonth completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/episodeComposition/latestByShow/tv/%@.json", self.businessUnitIdentifier, showUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (oldestMonth) {
        static NSDateFormatter *s_dateFormatter;
        static dispatch_once_t s_onceToken;
        dispatch_once(&s_onceToken, ^{
            s_dateFormatter = [[NSDateFormatter alloc] init];
            s_dateFormatter.dateFormat = @"yyyy-MM";
        });
        
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"maxPublishedDate" value:[s_dateFormatter stringFromDate:oldestMonth]] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGEpisodeComposition class] completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvShowsMatchingQuery:(NSString *)query withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListShow/tv.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGSearchResultShow class] rootKey:@"searchResultListShow" completionBlock:completionBlock];
}

#pragma mark Public radio services

- (SRGRequest *)radioChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channelList/radio.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)radioChannelWithUid:(NSString *)channelUid livestreamUid:(NSString *)livestreamUid completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/channel/%@/radio/nowAndNext.json", self.businessUnitIdentifier, channelUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (livestreamUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"livestreamId" value:livestreamUid] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)radioLivestreamsForChannelWithUid:(NSString *)channelUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    if (channelUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/livestreamsByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/livestreams.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestMediasForChannelWithUid:(NSString *)channelUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/latestByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioMostPopularMediasForChannelWithUid:(NSString *)channelUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/mostClickedByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestEpisodesForChannelWithUid:(NSString *)channelUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/latestEpisodesByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioEpisodesForDate:(NSDate *)date withChannelUid:(NSString *)channelUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateString = SRGDataProviderRequestDateString(date);
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/episodesByDateAndChannel/%@/%@.json", self.businessUnitIdentifier, dateString, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForChannelWithUid:(NSString *)channelUid completionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/showList/radio/alphabeticalByChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)radioShowWithUid:(NSString *)showUid completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/show/radio/%@.json", self.businessUnitIdentifier, showUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestEpisodesForShowWithUid:(NSString *)showUid oldestMonth:(NSDate *)oldestMonth completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/episodeComposition/latestByShow/radio/%@.json", self.businessUnitIdentifier, showUid];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (oldestMonth) {
        static NSDateFormatter *s_dateFormatter;
        static dispatch_once_t s_onceToken;
        dispatch_once(&s_onceToken, ^{
            s_dateFormatter = [[NSDateFormatter alloc] init];
            s_dateFormatter.dateFormat = @"yyyy-MM";
        });
        
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"maxPublishedDate" value:[s_dateFormatter stringFromDate:oldestMonth]] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGEpisodeComposition class] completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioShowsMatchingQuery:(NSString *)query withCompletionBlock:(SRGPaginatedSearchResultShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListShow/radio.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGSearchResultShow class] rootKey:@"searchResultListShow" completionBlock:completionBlock];
}

#pragma mark Song services

- (SRGFirstPageRequest *)radioSongsForChannelWithUid:(NSString *)channelUid
                                     completionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/songList/radio/byChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGSong class] rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

- (SRGRequest *)radioCurrentSongForChannelWithUid:(NSString *)channelUid
                                  completionBlock:(SRGSongCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/songList/radio/byChannel/%@.json", self.businessUnitIdentifier, channelUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:@[ [NSURLQueryItem queryItemWithName:@"onlyCurrentSong" value:@"true"] ]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGSong class] rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects.firstObject, error);
    }];
}

#pragma mark Live center services

- (SRGFirstPageRequest *)liveCenterVideosWithCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/scheduledLivestreams/livecenter.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

#pragma mark Public video services

- (SRGRequest *)videoWithUid:(NSString *)videoUid completionBlock:(SRGMediaCompletionBlock)completionBlock
{
    return [self videosWithUids:@[videoUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        completionBlock(medias.firstObject, error);
    }];
}

- (SRGRequest *)videosWithUids:(NSArray<NSString *> *)videoUids completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/video/byIds.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"ids" value:[videoUids componentsJoinedByString: @","]] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        completionBlock(objects, nil);
    }];
}

- (SRGRequest *)videoMediaCompositionWithUid:(NSString *)videoUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaComposition/video/%@.json", self.businessUnitIdentifier, videoUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMediaComposition class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGFirstPageRequest *)videosMatchingQuery:(NSString *)query withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListMedia/video.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGSearchResultMedia class] rootKey:@"searchResultListMedia" completionBlock:completionBlock];
}

#pragma mark Public audio services

- (SRGRequest *)audioWithUid:(NSString *)audioUid completionBlock:(SRGMediaCompletionBlock)completionBlock
{
    return [self audiosWithUids:@[audioUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        completionBlock(medias.firstObject, error);
    }];
}

- (SRGRequest *)audiosWithUids:(NSArray<NSString *> *)audioUids completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/audio/byIds.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"ids" value:[audioUids componentsJoinedByString: @","]] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        completionBlock(objects, nil);
    }];
}

- (SRGRequest *)audioMediaCompositionWithUid:(NSString *)audioUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaComposition/audio/%@.json", self.businessUnitIdentifier, audioUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMediaComposition class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGFirstPageRequest *)audiosMatchingQuery:(NSString *)query withCompletionBlock:(SRGPaginatedSearchResultMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/searchResultListMedia/audio.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy]];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGSearchResultMedia class] rootKey:@"searchResultListMedia" completionBlock:completionBlock];
}

#pragma mark Public common services

- (SRGRequest *)mediaWithURN:(SRGMediaURN *)mediaURN completionBlock:(SRGMediaCompletionBlock)completionBlock
{
    return [self mediasWithURNs:@[mediaURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        completionBlock(medias.firstObject, error);
    }];
}

- (SRGRequest *)mediasWithURNs:(NSArray<SRGMediaURN *> *)mediaURNs completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaList/byUrns.json"];
    NSArray<NSString *> *mediaURNStrings = [mediaURNs valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", @keypath(SRGMediaURN.new, URNString)]];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[mediaURNStrings componentsJoinedByString: @","]] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        completionBlock(objects, nil);
    }];
}

- (SRGRequest *)mediaCompositionWithURN:(SRGMediaURN *)mediaURN completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/mediaComposition/byUrn/%@.json", mediaURN.URNString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMediaComposition class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGRequest *)showWithURN:(SRGShowURN *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/show/byUrn/%@.json", showURN.URNString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] completionBlock:^(id  _Nullable object, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(object, error);
    }];
}

- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(SRGShowURN *)showURN
                                      completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/episodeComposition/latestByShow/byUrn/%@.json", showURN.URNString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGEpisodeComposition class] completionBlock:completionBlock];
}

#pragma mark Public module services

- (SRGRequest *)modulesWithType:(SRGModuleType)moduleType completionBlock:(SRGModuleListCompletionBlock)completionBlock
{
    NSString *moduleTypeString = [SRGModuleTypeJSONTransformer() reverseTransformedValue:@(moduleType)];
    NSString *resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/moduleConfigList/%@.json", self.businessUnitIdentifier, moduleTypeString.lowercaseString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGModule class] rootKey:@"moduleConfigList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForModuleWithType:(SRGModuleType)moduleType uid:(NSString *)uid sectionUid:(NSString *)sectionUid completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSString *moduleTypeString = [[SRGModuleTypeJSONTransformer() reverseTransformedValue:@(moduleType)] lowercaseString];
    
    NSString *resourcePath = nil;
    if (sectionUid) {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/latestByModuleAndSection/%@/%@/%@.json", self.businessUnitIdentifier, moduleTypeString, uid, sectionUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"integrationlayer/2.0/%@/mediaList/latestByModule/%@/%@.json", self.businessUnitIdentifier, moduleTypeString, uid];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSNumber * _Nullable total, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, error);
    }];
}

#pragma mark Public tokenization services

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
        
        completionBlock(tokenizedURLComponents.URL, nil);
    }];
}

#pragma mark Common implementation

- (NSURL *)URLForResourcePath:(NSString *)resourcePath withQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems
{
    NSURL *URL = [NSURL URLWithString:resourcePath relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"vector" value:@"appplay"]];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    URLComponents.queryItems = [fullQueryItems copy];
    
    return URLComponents.URL;
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
    return [NSString stringWithFormat:@"<%@: %p; serviceURL: %@; businessUnitIdentifier: %@>",
            [self class],
            self,
            self.serviceURL,
            self.businessUnitIdentifier];
}

@end

#pragma mark Functions

NSString *SRGDataProviderMarketingVersion(void)
{
    return [NSBundle srg_dataProviderBundle].infoDictionary[@"CFBundleShortVersionString"];
}

static NSString *SRGDataProviderRequestDateString(NSDate *date)
{
    NSCAssert(date, @"Expect a date");
    
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return [dateFormatter stringFromDate:date];
}
