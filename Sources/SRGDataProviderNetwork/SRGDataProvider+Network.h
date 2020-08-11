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
 *  A generic request for paginated single objects. Extract common values from a JSON dictionary, while letting the parsing
 *  still be customised.
 */
- (SRGFirstPageRequest *)pageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                            parser:(id (^)(NSDictionary *JSONDictionary, NSError * __autoreleasing *pError))parser
                                   completionBlock:(void (^)(id _Nullable object, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

/**
 *  A request to retrieve paginated lists of objects.
 */
- (SRGFirstPageRequest *)listPaginatedObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                                 modelClass:(Class)modelClass
                                                    rootKey:(NSString *)rootKey
                                            completionBlock:(void (^)(NSArray * _Nullable objects, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
