//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+RadioServices.h"

#import "SRGDataProvider+Network.h"

@import libextobjc;
@import SRGDataProviderRequests;

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
                                     channelUid:(NSString *)channelUid
                                            day:(SRGDay *)day
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestRadioEpisodesForVendor:vendor channelUid:channelUid day:day];
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
