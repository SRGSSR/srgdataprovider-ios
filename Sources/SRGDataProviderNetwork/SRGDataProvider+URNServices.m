//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+URNServices.h"

#import "SRGDataProvider+Network.h"

@import SRGDataProviderRequests;

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
