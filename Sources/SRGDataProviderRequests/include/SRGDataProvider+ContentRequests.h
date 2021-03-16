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
@interface SRGDataProvider (ContentRequests)

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                          uid:(NSString *)uid
                                    published:(BOOL)published
                                       atDate:(nullable NSDate *)date;
- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                    mediaType:(SRGMediaType)mediaType
                                    published:(BOOL)published
                                       atDate:(nullable NSDate *)date;
- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                 topicWithURN:(NSString *)topicURN
                                    published:(BOOL)published
                                       atDate:(nullable NSDate *)date;

- (NSURLRequest *)requestContentSectionForVendor:(SRGVendor)vendor
                                             uid:(NSString *)uid
                                       published:(BOOL)published;
- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                       contentSectionUid:(NSString *)contentSectionUid
                                  userId:(nullable NSString *)userId
                               published:(BOOL)published
                                  atDate:(nullable NSDate *)date;
- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                      contentSectionUid:(NSString *)contentSectionUid
                                 userId:(nullable NSString *)userId
                              published:(BOOL)published
                                 atDate:(nullable NSDate *)date;
- (NSURLRequest *)requestShowHighlightForVendor:(SRGVendor)vendor
                              contentSectionUid:(NSString *)contentSectionUid
                                         userId:(nullable NSString *)userId
                                      published:(BOOL)published
                                         atDate:(nullable NSDate *)date;

@end

NS_ASSUME_NONNULL_END
