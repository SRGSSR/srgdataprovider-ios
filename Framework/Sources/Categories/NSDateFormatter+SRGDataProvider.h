//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Date formatter extensions.
 */
@interface NSDateFormatter (SRGDataProvider)

/**
 *  Day formatter (yyyy-MM-dd).
 */
@property (class, nonatomic, readonly) NSDateFormatter *srgdataprovider_dayDateFormatter;

/**
 *  Month formatter (yyyy-MM).
 */
@property (class, nonatomic, readonly) NSDateFormatter *srgdataprovider_monthDateFormatter;

@end

NS_ASSUME_NONNULL_END
