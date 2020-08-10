//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGNetwork;

NS_ASSUME_NONNULL_BEGIN

@interface SRGDataProvider (Network)

- (SRGRequest *)fetchObjectWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                          completionBlock:(void (^)(id _Nullable object, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

- (SRGRequest *)listObjectsWithURLRequest:(NSURLRequest *)URLRequest
                               modelClass:(Class)modelClass
                                  rootKey:(NSString *)rootKey
                          completionBlock:(void (^)(NSArray * _Nullable objects, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

// Helper for common paginated request implementation. Extract common values from the JSON dictionary of IL responses,
// while letting the parser still be customised.
- (SRGFirstPageRequest *)pageRequestWithURLRequest:(NSURLRequest *)URLRequest
                                            parser:(id (^)(NSDictionary *JSONDictionary, NSError * __autoreleasing *pError))parser
                                   completionBlock:(void (^)(id _Nullable object, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

- (SRGFirstPageRequest *)listPaginatedObjectsWithURLRequest:(NSURLRequest *)URLRequest
                                                 modelClass:(Class)modelClass
                                                    rootKey:(NSString *)rootKey
                                            completionBlock:(void (^)(NSArray * _Nullable objects, NSDictionary<NSString *, id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
