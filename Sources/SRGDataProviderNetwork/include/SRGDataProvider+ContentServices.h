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
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
 *                   specific date.
 */
- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                             pageUid:(NSString *)pageUid
                           published:(BOOL)published
                              atDate:(nullable NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock;

/**
 *  Retrieve the default content page for medias of the specified type.
 *
 *  @param published Set this parameter to `YES` to look only for published pages.
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
 *                   specific date.
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
 *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
 *                   specific date.
 */
- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                        topicWithURN:(NSString *)topicURN
                           published:(BOOL)published
                              atDate:(nullable NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
