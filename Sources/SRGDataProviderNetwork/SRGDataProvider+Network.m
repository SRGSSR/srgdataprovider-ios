//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+Network.h"

@import SRGDataProviderModel;
@import SRGDataProviderRequests;

static NSString * const SRGParsedObjectKey = @"object";
static NSString * const SRGParsedNextURLKey = @"nextURL";

static NSDictionary *SRGDataProviderParser(NSData * _Nonnull data, id (^parser)(NSDictionary *, NSError **pError), NSError **pError)
{
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
}

@implementation SRGDataProvider (Network)

- (SRGRequest *)fetchObjectWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                          completionBlock:(void (^)(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
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
            // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
            //         (or no such entry at all for the episode composition request)
            // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
            return @[];
        }
    } completionBlock:^(id  _Nullable object, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *HTTPResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        completionBlock(object, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)pageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                            parser:(id (^)(NSDictionary *JSONDictionary, NSError * __autoreleasing *pError))parser
                                   completionBlock:(void (^)(id _Nullable object, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock
{
    return [[SRGFirstPageRequest objectRequestWithURLRequest:URLRequest session:self.session parser:^id _Nullable(NSData * _Nonnull data, NSError * _Nullable __autoreleasing * _Nullable pError) {
        return SRGDataProviderParser(data, parser, pError);
    } sizer:^NSURLRequest *(NSURLRequest * _Nonnull URLRequest, NSUInteger size) {
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

- (SRGFirstPageRequest *)clientSidePageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                              queryParameter:(NSString *)queryParameter
                                                      parser:(id  _Nonnull (^)(NSDictionary * _Nonnull, NSError *__autoreleasing  _Nullable * _Nullable))parser
                                             completionBlock:(void (^)(id _Nullable, NSDictionary<NSString *,id> * _Nonnull, SRGPage * _Nonnull, SRGPage * _Nullable, NSHTTPURLResponse * _Nullable, NSError * _Nullable))completionBlock
{
    return [[SRGFirstPageRequest objectRequestWithURLRequest:URLRequest session:self.session parser:^id _Nullable(NSData * _Nonnull data, NSError * _Nullable __autoreleasing * _Nullable pError) {
        return SRGDataProviderParser(data, parser, pError);
    } sizer:^NSURLRequest *(NSURLRequest * _Nonnull URLRequest, NSUInteger size) {
        NSURLRequest *URNsRequest = [SRGDataProvider URLRequestForURNsPageWithSize:size number:0 URLRequest:URLRequest queryParameter:queryParameter];
        NSCAssert(URNsRequest != nil, @"Invalid request construction");
        return URNsRequest;
    } paginator:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull URLRequest, NSDictionary<NSString *, id> * _Nullable parsedObjectDictionary, NSURLResponse * _Nullable response, NSUInteger size, NSUInteger number) {
        return [SRGDataProvider URLRequestForURNsPageWithSize:size number:number URLRequest:URLRequest queryParameter:queryParameter];
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
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
            return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:pError];
        }
        else {
            // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
            //         (or no such entry at all for the episode composition request)
            // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
            return @[];
        }
    } completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)clientSideListPaginatedObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                                       queryParameter:(NSString *)queryParameter
                                                           modelClass:(Class)modelClass
                                                              rootKey:(NSString *)rootKey
                                                      completionBlock:(void (^)(NSArray * _Nullable, NSDictionary<NSString *,id> * _Nonnull, SRGPage * _Nonnull, SRGPage * _Nullable, NSHTTPURLResponse * _Nullable, NSError * _Nullable))completionBlock
{
    return [self clientSidePageRequestWithURLRequest:URLRequest queryParameter:queryParameter parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:NSArray.class]) {
            return [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:pError];
        }
        else {
            return nil;
        }
    } completionBlock:completionBlock];
}

@end
