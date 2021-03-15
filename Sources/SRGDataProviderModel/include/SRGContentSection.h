//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A section of content.
 */
@interface SRGContentSection : SRGModel

/**
 *  The unique identifier of the section.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The vendor which the section belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  The section type.
 */
@property (nonatomic, readonly) SRGContentSectionType type;

/**
 *  `YES` iff the section has been published.
 */
@property (nonatomic, readonly, getter=isPublished) BOOL published;

/**
 *  `YES` iff the section contains personalized content.
 */
@property (nonatomic, readonly, getter=isPersonalized) BOOL personalized;

/**
 *  The date at which the section is made available.
 */
@property (nonatomic, readonly, nullable) NSDate *startDate;

/**
 *  The date at which the section is not available anymore.
 */
@property (nonatomic, readonly, nullable) NSDate *endDate;

@end

NS_ASSUME_NONNULL_END
