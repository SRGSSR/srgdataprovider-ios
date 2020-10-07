//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGNetwork;

NS_ASSUME_NONNULL_BEGIN

// Keys for access to parsed response information
static NSString * const SRGParsedTotalKey = @"total";
static NSString * const SRGParsedMediaAggregationsKey = @"mediaAggregations";
static NSString * const SRGParsedSearchSuggestionsKey = @"searchSuggestions";

/**
 *  Generic request implementation using SRG Network.
 */
@interface SRGDataProvider (Network)

/**
 *  A request to fetch a single object.
 */
- (SRGRequest *)fetchObjectWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                          completionBlock:(void (^)(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

/**
 *  A request to fetch a single array of objects.
 */
- (SRGRequest *)listObjectsWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                                  rootKey:(NSString *)rootKey
                          completionBlock:(void (^)(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

/**
 *  A generic request for paginated single objects, one per page. Parsing can be customized and pagination is returned
 *  in service responses.
 */
- (SRGFirstPageRequest *)pageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                            parser:(id (^)(NSDictionary *JSONDictionary, NSError * __autoreleasing *pError))parser
                                   completionBlock:(void (^)(id _Nullable object, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

/**
 *  A generic request for paginated single objects, one per page. Parsing can be customized and pagination is built
 *  client-side by reading a string comma-delimited strings from the specified query parameter.
 */
- (SRGFirstPageRequest *)clientSidePageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                              queryParameter:(NSString *)queryParameter
                                                      parser:(id (^)(NSDictionary *JSONDictionary, NSError * __autoreleasing *pError))parser
                                             completionBlock:(void (^)(id _Nullable object, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

/**
 *  A request to retrieve paginated lists of objects. Automatically parse objects of the specified class under the
 *  provided root key. Pagination is returned in service responses.
 */
- (SRGFirstPageRequest *)listPaginatedObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                                 modelClass:(Class)modelClass
                                                    rootKey:(NSString *)rootKey
                                            completionBlock:(void (^)(NSArray * _Nullable objects, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

/**
 *  A request to retrieve paginated lists of objects. Automatically parse objects of the specified class under the
 *  provided root key. Pagination is built client-side by reading a string comma-delimited strings from the specified
 *  query parameter.
 */
- (SRGFirstPageRequest *)listClientSidePaginatedObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                                       queryParameter:(NSString *)queryParameter
                                                           modelClass:(Class)modelClass
                                                              rootKey:(NSString *)rootKey
                                                      completionBlock:(void (^)(NSArray * _Nullable objects, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
