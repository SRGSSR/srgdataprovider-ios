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
                                     channelUid:(NSString *)channelUid
                                            day:(nullable SRGDay *)day;
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

NS_ASSUME_NONNULL_END
