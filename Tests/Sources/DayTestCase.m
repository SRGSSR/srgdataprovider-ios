//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

#import "SRGDay+Private.h"

@interface DayTestCase : XCTestCase

@end

@implementation DayTestCase

#pragma mark Tests

- (void)testInstantiation
{
    SRGDay *day1 = [SRGDay day:7 month:1 year:2016];
    XCTAssertEqualObjects(day1.string, @"2016-01-07");

    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.year = 2015;
    components2.month = 7;
    components2.day = 3;
    components2.hour = 9;
    components2.minute = 41;

    NSDate *date2 = [NSCalendar.currentCalendar dateFromComponents:components2];
    SRGDay *day2 = [SRGDay dayFromDate:date2];
    XCTAssertEqualObjects(day2.string, @"2015-07-03");
}

- (void)testPartialComponents
{
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    
    NSDate *date1 = [NSCalendar.currentCalendar dateFromComponents:components1];
    SRGDay *day1 = [SRGDay dayFromDate:date1];
    XCTAssertEqualObjects(day1.string, @"0001-01-01");
    
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.year = 2015;
    
    NSDate *date2 = [NSCalendar.currentCalendar dateFromComponents:components2];
    SRGDay *day2 = [SRGDay dayFromDate:date2];
    XCTAssertEqualObjects(day2.string, @"2015-01-01");
    
    NSDateComponents *components3 = [[NSDateComponents alloc] init];
    components3.month = 12;
    
    NSDate *date3 = [NSCalendar.currentCalendar dateFromComponents:components3];
    SRGDay *day3 = [SRGDay dayFromDate:date3];
    XCTAssertEqualObjects(day3.string, @"0001-12-01");
    
    NSDateComponents *components4 = [[NSDateComponents alloc] init];
    components4.day = 7;
    
    NSDate *date4 = [NSCalendar.currentCalendar dateFromComponents:components4];
    SRGDay *day4 = [SRGDay dayFromDate:date4];
    XCTAssertEqualObjects(day4.string, @"0001-01-07");
}

- (void)testHigherUnits
{
    SRGDay *day1 = [SRGDay day:40 month:1 year:2015];
    XCTAssertEqualObjects(day1.string, @"2015-02-09");
    
    SRGDay *day2 = [SRGDay day:10 month:15 year:2012];
    XCTAssertEqualObjects(day2.string, @"2013-03-10");
}

- (void)testEquality
{
    SRGDay *day1 = [SRGDay day:7 month:4 year:2010];
    SRGDay *day2 = [SRGDay day:7 month:4 year:2010];
    SRGDay *day3 = [SRGDay day:3 month:4 year:2010];
    SRGDay *day4 = [SRGDay day:7 month:4 year:2011];
    
    XCTAssertEqualObjects(day1, day2);
    XCTAssertNotEqualObjects(day1, day3);
    XCTAssertNotEqualObjects(day1, day4);
}

- (void)testCompare
{
    SRGDay *day1 = [SRGDay day:7 month:4 year:2010];
    SRGDay *day2 = [SRGDay day:7 month:4 year:2010];
    SRGDay *day3 = [SRGDay day:3 month:4 year:2010];
    SRGDay *day4 = [SRGDay day:7 month:4 year:2011];
    
    XCTAssertEqual([day1 compare:day2], NSOrderedSame);
    XCTAssertEqual([day1 compare:day3], NSOrderedDescending);
    XCTAssertEqual([day1 compare:day4], NSOrderedAscending);
    
    NSDateComponents *components5 = [[NSDateComponents alloc] init];
    components5.year = 2010;
    components5.month = 4;
    components5.day = 7;
    components5.hour = 9;
    components5.minute = 41;
    
    NSDate *date5 = [NSCalendar.currentCalendar dateFromComponents:components5];
    SRGDay *day5 = [SRGDay dayFromDate:date5];
    
    XCTAssertEqual([day1 compare:day5], NSOrderedSame);
}

- (void)testCopy
{
    SRGDay *day = [SRGDay day:7 month:5 year:2010];
    SRGDay *dayCopy = day.copy;
    XCTAssertEqualObjects(day, dayCopy);
}

- (void)testToday
{
    SRGDay *day1 = [SRGDay dayFromDate:NSDate.date];
    SRGDay *day2 = SRGDay.today;
    XCTAssertEqualObjects(day1, day2);
}

- (void)testUnitDrop
{
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    components1.year = 2013;
    components1.month = 4;
    components1.day = 5;
    components1.hour = 10;
    components1.minute = 45;
    components1.second = 27;
    
    NSDate *date1 = [NSCalendar.currentCalendar dateFromComponents:components1];
    SRGDay *day1 = [SRGDay dayFromDate:date1];
    
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.year = 2013;
    components2.month = 4;
    components2.day = 5;
    
    NSDate *date2 = [NSCalendar.currentCalendar dateFromComponents:components2];
    SRGDay *day2 = [SRGDay dayFromDate:date2];
    
    XCTAssertEqualObjects(day1, day2);
}

- (void)testAddition
{
    SRGDay *day = [SRGDay day:3 month:1 year:2016];
    
    SRGDay *day1 = [SRGDay dayByAddingDays:7 months:4 years:1 toDay:day];
    XCTAssertEqualObjects(day1.string, @"2017-05-10");
    
    SRGDay *day2 = [SRGDay dayByAddingDays:-4 months:-6 years:-1 toDay:day];
    XCTAssertEqualObjects(day2.string, @"2014-06-29");
    
    SRGDay *day3 = [SRGDay dayByAddingDays:50 months:20 years:0 toDay:day];
    XCTAssertEqualObjects(day3.string, @"2017-10-23");
    
    SRGDay *day4 = [SRGDay dayByAddingDays:-70 months:-15 years:0 toDay:day];
    XCTAssertEqualObjects(day4.string, @"2014-07-25");
}

- (void)testStartDay
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2015;
    components.month = 7;
    components.day = 3;
    
    NSDate *date = [NSCalendar.currentCalendar dateFromComponents:components];
    SRGDay *day = [SRGDay dayFromDate:date];
    XCTAssertEqualObjects(day.string, @"2015-07-03");
    
    SRGDay *yearStartDay = [SRGDay startDayForUnit:NSCalendarUnitYear containingDay:day];
    XCTAssertEqualObjects(yearStartDay.string, @"2015-01-01");
    
    SRGDay *monthStartDay = [SRGDay startDayForUnit:NSCalendarUnitMonth containingDay:day];
    XCTAssertEqualObjects(monthStartDay.string, @"2015-07-01");
}

- (void)testComponents
{
    SRGDay *fromDay = [SRGDay day:4 month:1 year:2014];
    SRGDay *toDay = [SRGDay day:8 month:5 year:2017];
    
    NSDateComponents *components1 = [SRGDay components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components1.year, 3);
    XCTAssertEqual(components1.month, 4);
    XCTAssertEqual(components1.day, 4);
    
    NSDateComponents *components2 = [SRGDay components:NSCalendarUnitYear | NSCalendarUnitMonth fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components2.year, 3);
    XCTAssertEqual(components2.month, 4);
    XCTAssertEqual(components2.day, NSDateComponentUndefined);
    
    NSDateComponents *components3 = [SRGDay components:NSCalendarUnitYear | NSCalendarUnitDay fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components3.year, 3);
    XCTAssertEqual(components3.month, NSDateComponentUndefined);
    XCTAssertEqual(components3.day, 124);
    
    NSDateComponents *components4 = [SRGDay components:NSCalendarUnitYear fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components4.year, 3);
    XCTAssertEqual(components4.month, NSDateComponentUndefined);
    XCTAssertEqual(components4.day, NSDateComponentUndefined);
    
    NSDateComponents *components5 = [SRGDay components:NSCalendarUnitMonth fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components5.year, NSDateComponentUndefined);
    XCTAssertEqual(components5.month, 40);
    XCTAssertEqual(components5.day, NSDateComponentUndefined);
    
    NSDateComponents *components6 = [SRGDay components:NSCalendarUnitDay fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components6.year, NSDateComponentUndefined);
    XCTAssertEqual(components6.month, NSDateComponentUndefined);
    XCTAssertEqual(components6.day, 1220);
    
    NSDateComponents *components7 = [SRGDay components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDay:fromDay toDay:toDay];
    XCTAssertEqual(components7.year, 3);
    XCTAssertEqual(components7.month, 4);
    XCTAssertEqual(components7.day, 4);
    XCTAssertEqual(components7.hour, 0);
    XCTAssertEqual(components7.minute, 0);
    XCTAssertEqual(components7.second, 0);
}

@end
