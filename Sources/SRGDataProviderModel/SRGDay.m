//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDay.h"

@interface SRGDay ()

@property (nonatomic) NSDateComponents *components;

@end

@implementation SRGDay

#pragma mark Class methods

+ (SRGDay *)today
{
    return [[self.class alloc] initFromDate:NSDate.date];
}

+ (SRGDay *)day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    components.month = month;
    components.year = year;
    
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    return [[self.class alloc] initFromDate:date];
}

+ (SRGDay *)dayFromDate:(NSDate *)date
{
    return [[self.class alloc] initFromDate:date];
}

+ (SRGDay *)dayByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years toDay:(SRGDay *)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = days;
    components.month = months;
    components.year = years;
    
    NSDate *date = [NSCalendar.currentCalendar dateByAddingComponents:components toDate:day.date options:0];
    return [[self.class alloc] initFromDate:date];
}

+ (SRGDay *)startDayForUnit:(NSCalendarUnit)unit containingDay:(SRGDay *)day
{
    NSDate *startDate;
    [NSCalendar.currentCalendar rangeOfUnit:unit startDate:&startDate interval:nil forDate:day.date];
    return [self dayFromDate:startDate];
}

+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDay:(SRGDay *)fromDay toDay:(SRGDay *)toDay
{
    return [NSCalendar.currentCalendar components:unitFlags fromDate:fromDay.date toDate:toDay.date options:0];
}

#pragma mark Object lifecycle

- (instancetype)initFromDate:(NSDate *)date
{
    if (self = [super init]) {
        self.components = [NSCalendar.currentCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    }
    return self;
}

#pragma mark Getters and setters

- (NSDate *)date
{
    return [NSCalendar.currentCalendar dateFromComponents:self.components];
}

- (NSString *)string
{
    static NSDateFormatter *s_dateFormatter;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_dateFormatter = [[NSDateFormatter alloc] init];
        [s_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        // No timezone specified here. This would not make sense, as no time within the day is provided anyway for
        // proper conversion.
        s_dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return [s_dateFormatter stringFromDate:self.date];
}

#pragma mark Comparison

- (NSComparisonResult)compare:(SRGDay *)aDay
{
    return [self.date compare:aDay.date];
}

@end
