//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

//--------------
// TODO: Hide after all requests migrated here
@interface SRGDataProvider (RequestsPrivate)

- (NSURLRequest *)URLRequestForResourcePath:(NSString *)resourcePath withQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems;

@end

OBJC_EXPORT NSString *SRGPathComponentForVendor(SRGVendor vendor);

//--------------

@interface SRGDataProvider (TvRequests)

- (NSURLRequest *)requestTvChannelsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvChannelForVendor:(SRGVendor)vendor
                                    withUid:(NSString *)channelUid;
- (NSURLRequest *)requestTvLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(nullable NSString *)livestreamUid
                                          fromDate:(nullable NSDate *)fromDate
                                            toDate:(nullable NSDate *)toDate;
- (NSURLRequest *)requestTvLivestreamsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvScheduledLivestreamsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvEditorialMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvLatestMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvMostPopularMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvSoonExpiringMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvTrendingMediasForVendor:(SRGVendor)vendor
                                         withLimit:(nullable NSNumber *)limit
                                    editorialLimit:(nullable NSNumber *)editorialLimit
                                      episodesOnly:(BOOL)episodesOnly;
- (NSURLRequest *)requestTvLatestEpisodesForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvEpisodesForVendor:(SRGVendor)vendor
                                         day:(nullable SRGDay *)day;
- (NSURLRequest *)requestTvTopicsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvShowsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTvShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query;

@end

@interface SRGDataProvider (RadioRequests)

- (NSURLRequest *)requestRadioChannelsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestRadioChannelForVendor:(SRGVendor)vendor
                                       withUid:(NSString *)channelUid
                                 livestreamUid:(nullable NSString *)livestreamUid;
- (NSURLRequest *)requestRadioLatestProgramsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                        livestreamUid:(nullable NSString *)livestreamUid
                                             fromDate:(nullable NSDate *)fromDate
                                               toDate:(nullable NSDate *)toDate;
- (NSURLRequest *)requestRadioLivestreamsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioLivestreamsForVendor:(SRGVendor)vendor
                                  contentProviders:(SRGContentProviders)contentProviders;
- (NSURLRequest *)requestRadioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioEpisodesForVendor:(SRGVendor)vendor
                                            day:(nullable SRGDay *)day
                                     channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioTopicsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestRadioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query;
- (NSURLRequest *)requestRadioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid;
- (NSURLRequest *)requestRadioCurrentSongForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid;

@end

@interface SRGDataProvider (LiveCenterRequests)

- (NSURLRequest *)requestLiveCenterVideosForVendor:(SRGVendor)vendor;

@end

@interface SRGDataProvider (SearchRequests)

- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                           matchingQuery:(nullable NSString *)query
                            withSettings:(nullable SRGMediaSearchSettings *)settings;
- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType;
- (NSURLRequest *)requestMostSearchedShowsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestVideosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(nullable NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded;

@end

@interface SRGDataProvider (RecommendationRequests)

- (NSURLRequest *)requestRecommendedMediasForURN:(NSString *)URN
                                          userId:(nullable NSString *)userId;

@end

@interface SRGDataProvider (ModuleRequests)

- (NSURLRequest *)requestModulesForVendor:(SRGVendor)vendor
                                     type:(SRGModuleType)moduleType;

@end

@interface SRGDataProvider (GeneralRequests)

- (NSURLRequest *)requestServiceMessageForVendor:(SRGVendor)vendor;

@end

@interface SRGDataProvider (PopularityRequests)

- (NSURLRequest *)requestIncreaseSocialCountForType:(SRGSocialCountType)type
                                                URN:(NSString *)URN
                                              event:(NSString *)event;
- (NSURLRequest *)requestIncreaseSearchResultsViewCountForShow:(SRGShow *)show;

@end

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
