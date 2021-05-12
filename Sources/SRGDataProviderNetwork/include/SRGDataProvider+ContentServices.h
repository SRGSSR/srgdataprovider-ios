//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProviderTypes.h"

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Content services supported by the data provider. These services return content configured by editors through
 *  the Play Application Configurator tool (PAC).
 */
@interface SRGDataProvider (ContentServices)

/**
 *  Retrieve a page of content given by its unique identifier.
 *
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or
 *                   at a specific date.
 */
- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                                 uid:(NSString *)uid
                           published:(BOOL)published
                              atDate:(nullable NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock;

/**
 *  Retrieve the default content page for medias of the specified type.
 *
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or
 *                   at a specific date.
 */
- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                           mediaType:(SRGMediaType)mediaType
                           published:(BOOL)published
                              atDate:(nullable NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock;

/**
 *  Retrieve a page of content for a specific topic.
 *
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or
 *                   at a specific date.
 */
- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                        topicWithURN:(NSString *)topicURN
                           published:(BOOL)published
                              atDate:(nullable NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock;

/**
 *  Retrieve a section of content given by its unique identifier.
 *
 *  @param published Set this parameter to `YES` to look only for published sections.
 */
- (SRGRequest *)contentSectionForVendor:(SRGVendor)vendor
                                    uid:(NSString *)uid
                              published:(BOOL)published
                    withCompletionBlock:(SRGContentSectionCompletionBlock)completionBlock;

/**
 *  Retrieve medias for a content section.
 *
 *  @param userId    An optional user identifier.
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or
 *                   at a specific date.
 *
 *  @discussion The section itself must be of type `SRGContentSectionTypeMedias`.
 */
- (SRGFirstPageRequest *)mediasForVendor:(SRGVendor)vendor
                       contentSectionUid:(NSString *)contentSectionUid
                                  userId:(nullable NSString *)userId
                               published:(BOOL)published
                                  atDate:(nullable NSDate *)date
                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock;

/**
 *  Retrieve shows for a content section.
 *
 *  @param userId    An optional user identifier.
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or
 *                   at a specific date.
 *
 *  @discussion The section itself must be of type `SRGContentSectionTypeShows`.
 */
- (SRGFirstPageRequest *)showsForVendor:(SRGVendor)vendor
                      contentSectionUid:(NSString *)contentSectionUid
                                 userId:(nullable NSString *)userId
                              published:(BOOL)published
                                 atDate:(nullable NSDate *)date
                    withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock;

/**
 *  Retrieve the show and medias for a content section.
 *
 *  @param userId    An optional user identifier.
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or
 *                   at a specific date.
 *
 *  @discussion The section itself must be of type `SRGContentSectionTypeShowAndMedias`.
 */
- (SRGFirstPageRequest *)showAndMediasForVendor:(SRGVendor)vendor
                              contentSectionUid:(NSString *)contentSectionUid
                                         userId:(nullable NSString *)userId
                                      published:(BOOL)published
                                         atDate:(nullable NSDate *)date
                            withCompletionBlock:(SRGPaginatedShowAndMediaListCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
