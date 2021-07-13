//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of TV-oriented services supported by the data provider. Radio channels have separate identities and programs,
 *  this is why retrieving media lists requires the unique identifier of a channel to be specified.
 */
@interface SRGDataProvider (RadioServices)

/**
 *  @name Channels and livestreams
 */

/**
 *  List of radio channels.
 */
- (SRGRequest *)radioChannelsForVendor:(SRGVendor)vendor
                   withCompletionBlock:(SRGChannelListCompletionBlock)completionBlock;

/**
 *  Specific radio channel. Use this request to obtain complete channel information, including current and next programs.
 *
 *  @param livestreamUid An optional media unique identifier (usually regional, but might be the main one). If provided,
 *                       the program of the specified live stream is used, otherwise the one of the main channel.
 */
- (SRGRequest *)radioChannelForVendor:(SRGVendor)vendor
                              withUid:(NSString *)channelUid
                        livestreamUid:(nullable NSString *)livestreamUid
                      completionBlock:(SRGChannelCompletionBlock)completionBlock;

/**
 *  Latest programs for a specific radio channel, including current and next programs. An optional date range (possibly
 *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
 *  provided, only programs up to the current date are returned.
 *
 *  @param livestreamUid An optional media unique identifier (usually the main one). If provided,
 *                       the program of the specified livestream is used, otherwise the one of the main channel.
 *
 *  @discussion Though the completion block does not return an array directly, this request supports pagination (for programs
 *              returned in the program composition object).
 */
- (SRGFirstPageRequest *)radioLatestProgramsForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                        livestreamUid:(nullable NSString *)livestreamUid
                                             fromDate:(nullable NSDate *)fromDate
                                               toDate:(nullable NSDate *)toDate
                                  withCompletionBlock:(SRGPaginatedProgramCompositionCompletionBlock)completionBlock;

/**
 *  List of radio livestreams for a channel.
 *
 *  @param channelUid The channel uid for which audio livestreams (main and regional) must be retrieved.
 */
- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  List of radio livestreams.
 *
 *  @param contentProviders The content providers to return radio livestreams for.
 */
- (SRGRequest *)radioLivestreamsForVendor:(SRGVendor)vendor
                         contentProviders:(SRGContentProviders)contentProviders
                      withCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

/**
 *  @name Media and episode retrieval
 */

/**
 *  Latest medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestMediasForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Most popular medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioMostPopularMediasForVendor:(SRGVendor)vendor
                                              channelUid:(NSString *)channelUid
                                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest episodes for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestEpisodesForVendor:(SRGVendor)vendor
                                           channelUid:(NSString *)channelUid
                                  withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Episodes available for a given day, for the specific channel.
 *
 *  @param day The day. If `nil` today is used.
 */
- (SRGFirstPageRequest *)radioEpisodesForVendor:(SRGVendor)vendor
                                     channelUid:(NSString *)channelUid
                                            day:(nullable SRGDay *)day
                            withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Latest video medias for a specific channel.
 */
- (SRGFirstPageRequest *)radioLatestVideosForVendor:(SRGVendor)vendor
                                         channelUid:(NSString *)channelUid
                                withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  @name Topics
 */

/**
 *  Topics.
 */
- (SRGRequest *)radioTopicsForVendor:(SRGVendor)vendor
                 withCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;

/**
 *  @name Shows
 */

/**
 *  Shows by channel.
 */
- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query, returning the matching URN list.
 *
 *  @discussion Some business units only support full-text search, not partial matching. To get complete show objects,
 *              call the `-showsWithURNs:completionBlock:` request with the returned URN list.
 */
- (SRGFirstPageRequest *)radioShowsForVendor:(SRGVendor)vendor
                               matchingQuery:(NSString *)query
                         withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock;

/**
 *  @name Song list
 */

/**
 *  Song list by channel.
 */
- (SRGFirstPageRequest *)radioSongsForVendor:(SRGVendor)vendor
                                  channelUid:(NSString *)channelUid
                         withCompletionBlock:(SRGPaginatedSongListCompletionBlock)completionBlock;

/**
 *  Current song by channel.
 *
 *  @discussion If no song is currently being played the completion block is called with both song and error set to `nil`.
 */
- (SRGRequest *)radioCurrentSongForVendor:(SRGVendor)vendor
                               channelUid:(NSString *)channelUid
                      withCompletionBlock:(SRGSongCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
