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
 *  Start day for a given range of unit (see `NSCalendarUnit` for possible values) and a day.
 */
+ (SRGDay *)startDayForRangeOfUnit:(NSCalendarUnit)unit day:(SRGDay *)day;

/**
 *  Returns the date components separating two given days.
 */
+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDay:(SRGDay *)fromDay toDay:(SRGDay *)toDay;

/**
 *  Indicates the ordering of the receiver and another given day.
 */
- (NSComparisonResult)compare:(SRGDay *)day;

@end

NS_ASSUME_NONNULL_END
