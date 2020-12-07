//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common `NSURLRequest` builders. Refer to the service documentation for more information about the purpose and
 *  parameters of each request.
 */
@interface SRGDataProvider (URNRequests)

/**
 *  Attempts to split a request whose requested item list is provided through a query parameter containing a list
 *  of URNs. If successful the request for the URNs for the specified page is returned, otherwise `nil`.
 *
 *  Note that the original request is cloned to preserve its content.
 */
+ (nullable NSURLRequest *)URLRequestForURNsPageWithSize:(NSUInteger)size
                                                  number:(NSUInteger)number
                                              URLRequest:(NSURLRequest *)URLRequest
                                          queryParameter:(NSString *)queryParameter;

- (NSURLRequest *)requestMediaWithURN:(NSString *)mediaURN;
- (NSURLRequest *)requestMediasWithURNs:(NSArray<NSString *> *)mediaURNs;
- (NSURLRequest *)requestLatestMediasForTopicWithURN:(NSString *)topicURN;
- (NSURLRequest *)requestMostPopularMediasForTopicWithURN:(NSString *)topicURN;
- (NSURLRequest *)requestMediaCompositionForURN:(NSString *)mediaURN
                                     standalone:(BOOL)standalone;
- (NSURLRequest *)requestShowWithURN:(NSString *)showURN;
- (NSURLRequest *)requestShowsWithURNs:(NSArray<NSString *> *)showURNs;
- (NSURLRequest *)requestLatestEpisodesForShowWithURN:(NSString *)showURN
                                maximumPublicationDay:(nullable SRGDay *)maximumPublicationDay;
- (NSURLRequest *)requestLatestMediasForShowWithURN:(NSString *)showURN;
- (NSURLRequest *)requestLatestMediasForShowsWithURNs:(NSArray<NSString *> *)showURNs
                                               filter:(SRGMediaFilter)filter
                                maximumPublicationDay:(nullable SRGDay *)maximumPublicationDay;
- (NSURLRequest *)requestLatestMediasForModuleWithURN:(NSString *)moduleURN;

@end

NS_ASSUME_NONNULL_END
