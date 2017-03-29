//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A section is a collection of medias part of a global context (e.g. a module config, like an event).
 */
@interface SRGSection : SRGModel <SRGMetadata>

/**
 *  The unique identifier of the section.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The start date at which the section should be made available.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The start date at which the section should not be made available anymore.
 */
@property (nonatomic, readonly) NSDate *endDate;

@end

NS_ASSUME_NONNULL_END
