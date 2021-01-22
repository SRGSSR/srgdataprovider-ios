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
@interface SRGDataProvider (SearchRequests)

- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                           matchingQuery:(nullable NSString *)query
                            withSettings:(nullable SRGMediaSearchSettings *)settings;
- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType;
- (NSURLRequest *)requestMostSearchedShowsForVendor:(SRGVendor)vendor
                                       transmission:(SRGTransmission)transmission;
- (NSURLRequest *)requestVideosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(nullable NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded;

@end

NS_ASSUME_NONNULL_END
