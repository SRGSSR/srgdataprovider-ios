//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Represents a month and provides basic associated arithmetic.
 */
@interface SRGMonth : MTLModel

/**
 *  The current month.
 */
@property (class, nonatomic, readonly) SRGMonth *currentMonth;

/**
 *  Month for a given year.
 */
+ (SRGMonth *)month:(NSInteger)month year:(NSInteger)year;

/**
 *  Month from a given date. Units different from month or year are lost.
 */
+ (SRGMonth *)monthFromDate:(NSDate *)date;

/**
 *  Adds a given number of months and years (can be negative) to a month.
 */
+ (SRGMonth *)monthByAddingMonths:(NSInteger)months years:(NSInteger)years toMonth:(SRGMonth *)month;

/**
 *  Returns the date components separating two given months.
 */
+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromMonth:(SRGMonth *)fromMonth toMonth:(SRGMonth *)toMonth;

@end

NS_ASSUME_NONNULL_END
