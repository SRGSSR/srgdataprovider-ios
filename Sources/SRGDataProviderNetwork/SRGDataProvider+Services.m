//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+Services.h"

#import "SRGDataProvider+Network.h"

@import SRGDataProviderRequests;

// Keys for access to parsed response information
// TODO: Share these keys
static NSString * const SRGParsedObjectKey = @"object";
static NSString * const SRGParsedNextURLKey = @"nextURL";
static NSString * const SRGParsedTotalKey = @"total";
static NSString * const SRGParsedMediaAggregationsKey = @"mediaAggregations";
static NSString * const SRGParsedSearchSuggestionsKey = @"searchSuggestions";

@import libextobjc;

@implementation SRGDataProvider (TVServices)

- (SRGRequest *)tvChannelsForVendor:(SRGVendor)vendor
                withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVChannelsForVendor:vendor];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGChannel.class rootKey:@"channelList" completionBlock:completionBlock];
}

- (SRGRequest *)tvChannelForVendor:(SRGVendor)vendor
                           withUid:(NSString *)channelUid
                   completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVChannelForVendor:vendor withUid:channelUid];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGChannel.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(NSString *)livestreamUid
                                          fromDate:(NSDate *)fromDate
                                            toDate:(NSDate *)toDate
                               withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVLatestProgramsForVendor:vendor channelUid:channelUid livestreamUid:livestreamUid fromDate:fromDate toDate:toDate];
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        return [MTLJSONAdapter modelOfClass:SRGProgramComposition.class fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id _Nullable object, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvLivestreamsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVLivestreamsForVendor:vendor];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvScheduledLivestreamsForVendor:(SRGVendor)vendor
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVScheduledLivestreamsForVendor:vendor];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvEditorialMediasForVendor:(SRGVendor)vendor
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVEditorialMediasForVendor:vendor];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvLatestMediasForVendor:(SRGVendor)vendor
                             withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVLatestMediasForVendor:vendor];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvMostPopularMediasForVendor:(SRGVendor)vendor
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVMostPopularMediasForVendor:vendor];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvSoonExpiringMediasForVendor:(SRGVendor)vendor
                                   withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVSoonExpiringMediasForVendor:vendor];
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
    NSURLRequest *URLRequest = [self requestTVTrendingMediasForVendor:vendor withLimit:limit editorialLimit:editorialLimit episodesOnly:episodesOnly];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvLatestEpisodesForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVLatestEpisodesForVendor:vendor];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvEpisodesForVendor:(SRGVendor)vendor
                                         day:(SRGDay *)day
                         withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVEpisodesForVendor:vendor day:day];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)tvTopicsForVendor:(SRGVendor)vendor
              withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVTopicsForVendor:vendor];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGTopic.class rootKey:@"topicList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                      withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVShowsForVendor:vendor];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)tvShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query
                      withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestTVShowsForVendor:vendor matchingQuery:query];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultShowList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], page, nextPage, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (RadioServices)

- (SRGRequest *)radioChannelsForVendor:(SRGVendor)vendor withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioChannelsForVendor:vendor];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGChannel.class rootKey:@"channelList" completionBlock:completionBlock];
}

- (SRGRequest *)radioChannelForVendor:(SRGVendor)vendor
                              withUid:(NSString *)channelUid
                        livestreamUid:(NSString *)livestreamUid
                      completionBlock:(SRGChannelCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioChannelForVendor:vendor withUid:channelUid livestreamUid:livestreamUid];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGChannel.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioLatestProgramsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                        livestreamUid:(NSString *)livestreamUid
                                             fromDate:(NSDate *)fromDate
                                               toDate:(NSDate *)toDate
                                  withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioLatestProgramsForVendor:vendor channelUid:channelUid livestreamUid:livestreamUid fromDate:fromDate toDate:toDate];
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
    NSURLRequest *URLRequest = [self requestRadioLivestreamsForVendor:vendor channelUid:channelUid];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                         contentProviders:(SRGContentProviders)contentProviders
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioLivestreamsForVendor:vendor contentProviders:contentProviders];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioLatestMediasForVendor:vendor channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioMostPopularMediasForVendor:vendor channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioLatestEpisodesForVendor:vendor channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioLatestVideosForVendor:vendor channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioEpisodesForVendor:(SRGVendor)vendor
                                            day:(SRGDay *)day
                                     channelUid:(NSString *)channelUid
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioEpisodesForVendor:vendor day:day channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioTopicsForVendor:(SRGVendor)vendor
                 withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioTopicsForVendor:vendor];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGTopic.class rootKey:@"topicList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioShowsForVendor:vendor channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
                         withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioShowsForVendor:vendor matchingQuery:query];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultShowList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)radioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioSongsForVendor:vendor channelUid:channelUid];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSong.class rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)radioCurrentSongForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGSongCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioCurrentSongForVendor:vendor channelUid:channelUid];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGSong.class rootKey:@"songList" completionBlock:^(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects.firstObject, HTTPResponse, error);
    }];
}

@end

@implementation SRGDataProvider (LiveCenterServices)


- (SRGFirstPageRequest *)liveCenterVideosForVendor:(SRGVendor)vendor
                               withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestLiveCenterVideosForVendor:vendor];
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
    NSURLRequest *URLRequest = [self requestMediasForVendor:vendor matchingQuery:query withSettings:settings];
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
    NSURLRequest *URLRequest = [self requestShowsForVendor:vendor matchingQuery:query mediaType:mediaType];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGSearchResult.class rootKey:@"searchResultShowList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        NSArray<NSString *> *URNs = [objects valueForKeyPath:@keypath(SRGSearchResult.new, URN)];
        completionBlock(URNs, metadata[SRGParsedTotalKey], page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)mostSearchedShowsForVendor:(SRGVendor)vendor withCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMostSearchedShowsForVendor:vendor];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
                         completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestVideosForVendor:vendor withTags:tags excludedTags:excludedTags fullLengthExcluded:fullLengthExcluded];
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
    NSURLRequest *URLRequest = [self requestRecommendedMediasForURN:URN userId:userId];
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
    NSURLRequest *URLRequest = [self requestModulesForVendor:vendor type:moduleType];
    return [self listObjectsWithURLRequest:URLRequest modelClass:SRGModule.class rootKey:@"moduleConfigList" completionBlock:completionBlock];
}

@end

@implementation SRGDataProvider (GeneralServices)

- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestServiceMessageForVendor:vendor];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGServiceMessage.class completionBlock:completionBlock];
}

@end

@implementation SRGDataProvider (PopularityServices)

- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                                       URN:(NSString *)URN
                                     event:(NSString *)event
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestIncreaseSocialCountForType:type URN:URN event:event];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGSocialCountOverview.class completionBlock:completionBlock];
}

- (SRGRequest *)increaseSearchResultsViewCountForShow:(SRGShow *)show
                                  withCompletionBlock:(SRGShowStatisticsOverviewCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestIncreaseSearchResultsViewCountForShow:show];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShowStatisticsOverview.class completionBlock:completionBlock];
}

@end

@implementation SRGDataProvider (URNServices)

- (SRGRequest *)mediaWithURN:(NSString *)mediaURN completionBlock:(SRGMediaCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMediaWithURN:mediaURN];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGMedia.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)mediasWithURNs:(NSArray<NSString *> *)mediaURNs completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMediasWithURNs:mediaURNs];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestLatestMediasForTopicWithURN:topicURN];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)mostPopularMediasForTopicWithURN:(NSString *)topicURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMostPopularMediasForTopicWithURN:topicURN];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGRequest *)mediaCompositionForURN:(NSString *)mediaURN standalone:(BOOL)standalone withCompletionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMediaCompositionForURN:mediaURN standalone:standalone];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGMediaComposition.class completionBlock:completionBlock];
}

- (SRGRequest *)showWithURN:(NSString *)showURN completionBlock:(SRGShowCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestShowWithURN:showURN];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShow.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)showsWithURNs:(NSArray<NSString *> *)showURNs completionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestShowsWithURNs:showURNs];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestEpisodesForShowWithURN:(NSString *)showURN maximumPublicationDay:(SRGDay *)maximumPublicationDay completionBlock:(SRGPaginatedEpisodeCompositionCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestLatestEpisodesForShowWithURN:showURN maximumPublicationDay:maximumPublicationDay];
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        return [MTLJSONAdapter modelOfClass:SRGEpisodeComposition.class fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id _Nullable object, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)latestMediasForModuleWithURN:(NSString *)moduleURN completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestLatestMediasForModuleWithURN:moduleURN];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

@end
