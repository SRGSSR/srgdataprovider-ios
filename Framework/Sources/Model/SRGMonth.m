//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMonth.h"

@interface SRGMonth ()

@property (nonatomic) NSDateComponents *components;

@end

@implementation SRGMonth

#pragma mark Class methods

+ (SRGMonth *)currentMonth
{
    return [[self.class alloc] initFromDate:NSDate.date];
}

+ (SRGMonth *)month:(NSInteger)month year:(NSInteger)year
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month;
    components.year = year;
    
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    return [[self.class alloc] initFromDate:date];
}

+ (SRGMonth *)monthFromDate:(NSDate *)date
{
    return [[self.class alloc] initFromDate:date];
}

+ (SRGMonth *)monthByAddingMonths:(NSInteger)months years:(NSInteger)years toMonth:(SRGMonth *)month
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = months;
    components.year = years;
    
    NSDate *date = [NSCalendar.currentCalendar dateByAddingComponents:components toDate:month.date options:0];
    return [[self.class alloc] initFromDate:date];
}

+ (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromMonth:(SRGMonth *)fromMonth toMonth:(SRGMonth *)toMonth
{
    return [NSCalendar.currentCalendar components:unitFlags fromDate:fromMonth.date toDate:toMonth.date options:0];
}

#pragma mark Object lifecycle

- (instancetype)initFromDate:(NSDate *)date
{
    if (self = [super init]) {
        self.components = [NSCalendar.currentCalendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
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
        s_dateFormatter.dateFormat = @"yyyy-MM";
    });
    return [s_dateFormatter stringFromDate:self.date];
}

@end
