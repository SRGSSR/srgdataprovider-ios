//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of search-oriented services supported by the data provider.
 */
@interface SRGDataProvider (SearchServices)

/**
 *  Search medias matching a specific query.
 *
 *  @discussion To get complete media objects, call the `-mediasWithURNs:completionBlock:` request with the returned
 *              URN list. Refer to the Service availability matrix for information about which vendors support settings.
 *              By default aggregations are returned, which can lead to longer response times. If you do not need
 *              aggregations, provide a settings object to disable them.
 */
- (SRGFirstPageRequest *)mediasForVendor:(SRGVendor)vendor
                           matchingQuery:(nullable NSString *)query
                            withSettings:(nullable SRGMediaSearchSettings *)settings
                         completionBlock:(SRGPaginatedMediaSearchCompletionBlock)completionBlock;

/**
 *  Search shows matching a specific query.
 *
 *  @param mediaType If set to a value different from `SRGMediaTypeNone`, filter shows for which content of the specified
 *                   type is available. To get complete show objects, call the `-showsWithURNs:completionBlock:` request
 *                   with the returned URN list.
 */
- (SRGFirstPageRequest *)showsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType
                    withCompletionBlock:(SRGPaginatedShowSearchCompletionBlock)completionBlock;

/**
 *  Retrieve the list of shows which are searched the most.
 *
 *  @param transmission If set to a value different from `SRGTransmissionNone`, filter most searched shows for the specified
 *                      transmission.
 */
- (SRGRequest *)mostSearchedShowsForVendor:(SRGVendor)vendor
                      matchingTransmission:(SRGTransmission)transmission
                       withCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

/**
 *  List medias with specific tags.
 *
 *  @param tags               List of tags (at least one is required).
 *  @param excludedTags       An optional list of excluded tags.
 *  @param fullLengthExcluded Set to `YES` to exclude full length videos.
 */
- (SRGFirstPageRequest *)videosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(nullable NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
                         completionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
