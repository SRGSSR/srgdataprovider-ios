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
- (NSURLRequest *)requestLatestMediasForModuleWithURN:(NSString *)moduleURN;

@end

NS_ASSUME_NONNULL_END
