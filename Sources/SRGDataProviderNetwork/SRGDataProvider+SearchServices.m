//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+SearchServices.h"

#import "SRGDataProvider+Network.h"

@import libextobjc;
@import SRGDataProviderRequests;

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

- (SRGRequest *)mostSearchedShowsForVendor:(SRGVendor)vendor transmission:(SRGTransmission)transmission withCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMostSearchedShowsForVendor:vendor transmission:transmission];
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
