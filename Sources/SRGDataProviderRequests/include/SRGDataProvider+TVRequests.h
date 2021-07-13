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
@interface SRGDataProvider (TVRequests)

- (NSURLRequest *)requestTVChannelsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVChannelForVendor:(SRGVendor)vendor
                                    withUid:(NSString *)channelUid;
- (NSURLRequest *)requestTVLatestProgramsForVendor:(SRGVendor)vendor
                                        channelUid:(NSString *)channelUid
                                     livestreamUid:(nullable NSString *)livestreamUid
                                          fromDate:(nullable NSDate *)fromDate
                                            toDate:(nullable NSDate *)toDate;
- (NSURLRequest *)requestTVProgramsForVendor:(SRGVendor)vendor
                                         day:(nullable SRGDay *)day;
- (NSURLRequest *)requestTVLivestreamsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVScheduledLivestreamsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVEditorialMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVHeroStageMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVLatestMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVMostPopularMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVSoonExpiringMediasForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVTrendingMediasForVendor:(SRGVendor)vendor
                                         withLimit:(nullable NSNumber *)limit
                                    editorialLimit:(nullable NSNumber *)editorialLimit
                                      episodesOnly:(BOOL)episodesOnly;
- (NSURLRequest *)requestTVLatestEpisodesForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVLatestWebFirstEpisodesForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVEpisodesForVendor:(SRGVendor)vendor
                                         day:(nullable SRGDay *)day;
- (NSURLRequest *)requestTVTopicsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVShowsForVendor:(SRGVendor)vendor;
- (NSURLRequest *)requestTVShowsForVendor:(SRGVendor)vendor
                            matchingQuery:(NSString *)query;

@end
NS_ASSUME_NONNULL_END
