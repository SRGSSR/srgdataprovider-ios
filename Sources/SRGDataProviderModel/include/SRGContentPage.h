//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContentSection.h"
#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A page of content.
 */
@interface SRGContentPage : SRGModel

/**
 *  The unique identifier of the page.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The vendor which the page belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  The page title.
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  `YES` iff the page has been published.
 */
@property (nonatomic, readonly, getter=isPublished) BOOL published;

/**
 *  The URN of the associated topic, if any.
 */
@property (nonatomic, readonly, copy, nullable) NSString *topicURN;

/**
 *  The sections contained in the page.
 */
@property (nonatomic, readonly) NSArray<SRGContentSection *> *sections;

@end

NS_ASSUME_NONNULL_END
