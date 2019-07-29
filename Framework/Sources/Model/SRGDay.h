//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Represents a day and provides basic associated arithmetic.
 */
@interface SRGDay : MTLModel

/**
 *  Today.
 */
@property (class, nonatomic, readonly) SRGDay *today;

/**
 *  Day for a month and year.
 */
+ (SRGDay *)day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

/**
 *  Day from a given date. Units different from day, month or year are lost.
 */
+ (SRGDay *)dayFromDate:(NSDate *)date;

/**
 *  Adds a given number of days, months and years (can be negative) to a day.
 */
+ (SRGDay *)dayByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years toDay:(SRGDay *)day;

/**
 *  Returns the date components separating two given days.
 */
+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDay:(SRGDay *)fromDay toDay:(SRGDay *)toDay;

@end

NS_ASSUME_NONNULL_END
