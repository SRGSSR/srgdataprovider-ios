//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

#import "SRGMonth+Private.h"

@interface MonthTestCase : XCTestCase

@end

@implementation MonthTestCase

#pragma mark Tests

- (void)testInstantiation
{
    SRGMonth *month1 = [SRGMonth month:1 year:2016];
    XCTAssertEqualObjects(month1.string, @"2016-01");
    
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.year = 2015;
    components2.month = 7;
    
    NSDate *date2 = [NSCalendar.currentCalendar dateFromComponents:components2];
    SRGMonth *month2 = [SRGMonth monthFromDate:date2];
    XCTAssertEqualObjects(month2.string, @"2015-07");
}

- (void)testPartialComponents
{
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    
    NSDate *date1 = [NSCalendar.currentCalendar dateFromComponents:components1];
    SRGMonth *month1 = [SRGMonth monthFromDate:date1];
    XCTAssertEqualObjects(month1.string, @"0001-01");
    
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.year = 2015;
    
    NSDate *date2 = [NSCalendar.currentCalendar dateFromComponents:components2];
    SRGMonth *month2 = [SRGMonth monthFromDate:date2];
    XCTAssertEqualObjects(month2.string, @"2015-01");
    
    NSDateComponents *components3 = [[NSDateComponents alloc] init];
    components3.month = 12;
    
    NSDate *date3 = [NSCalendar.currentCalendar dateFromComponents:components3];
    SRGMonth *month3 = [SRGMonth monthFromDate:date3];
    XCTAssertEqualObjects(month3.string, @"0001-12");
}

- (void)testHigherUnits
{
    SRGMonth *month = [SRGMonth month:14 year:2016];
    XCTAssertEqualObjects(month.string, @"2017-02");
}

- (void)testEquality
{
    SRGMonth *month1 = [SRGMonth month:4 year:2010];
    SRGMonth *month2 = [SRGMonth month:4 year:2010];
    SRGMonth *month3 = [SRGMonth month:5 year:2010];
    
    XCTAssertEqualObjects(month1, month2);
    XCTAssertNotEqualObjects(month1, month3);
}

- (void)testCopy
{
    SRGMonth *month = [SRGMonth month:5 year:2010];
    SRGMonth *monthCopy = [month copy];
    XCTAssertEqualObjects(month, monthCopy);
}

- (void)testCurrentMonth
{
    SRGMonth *month1 = [SRGMonth monthFromDate:NSDate.date];
    SRGMonth *month2 = SRGMonth.currentMonth;
    XCTAssertEqualObjects(month1, month2);
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
    SRGMonth *month1 = [SRGMonth monthFromDate:date1];
    
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    components2.year = 2013;
    components2.month = 4;
    
    NSDate *date2 = [NSCalendar.currentCalendar dateFromComponents:components2];
    SRGMonth *month2 = [SRGMonth monthFromDate:date2];
    
    XCTAssertEqualObjects(month1, month2);
}

- (void)testAddition
{
    SRGMonth *month = [SRGMonth month:1 year:2016];
    
    SRGMonth *month1 = [SRGMonth monthByAddingMonths:4 years:1 toMonth:month];
    XCTAssertEqualObjects(month1.string, @"2017-05");
    
    SRGMonth *month2 = [SRGMonth monthByAddingMonths:-6 years:-1 toMonth:month];
    XCTAssertEqualObjects(month2.string, @"2014-07");
    
    SRGMonth *month3 = [SRGMonth monthByAddingMonths:20 years:0 toMonth:month];
    XCTAssertEqualObjects(month3.string, @"2017-09");
    
    SRGMonth *month4 = [SRGMonth monthByAddingMonths:-15 years:0 toMonth:month];
    XCTAssertEqualObjects(month4.string, @"2014-10");
}

- (void)testComponents
{
    SRGMonth *fromMonth = [SRGMonth month:1 year:2014];
    SRGMonth *toMonth = [SRGMonth month:5 year:2017];
    
    NSDateComponents *components1 = [SRGMonth components:NSCalendarUnitYear | NSCalendarUnitMonth fromMonth:fromMonth toMonth:toMonth];
    XCTAssertEqual(components1.year, 3);
    XCTAssertEqual(components1.month, 4);
    
    NSDateComponents *components2 = [SRGMonth components:NSCalendarUnitYear fromMonth:fromMonth toMonth:toMonth];
    XCTAssertEqual(components2.year, 3);
    XCTAssertEqual(components2.month, NSDateComponentUndefined);
    
    NSDateComponents *components3 = [SRGMonth components:NSCalendarUnitMonth fromMonth:fromMonth toMonth:toMonth];
    XCTAssertEqual(components3.year, NSDateComponentUndefined);
    XCTAssertEqual(components3.month, 40);
    
    NSDateComponents *components4 = [SRGMonth components:NSCalendarUnitDay fromMonth:fromMonth toMonth:toMonth];
    XCTAssertEqual(components4.day, 1216);
    
    NSDateComponents *components5 = [SRGMonth components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromMonth:fromMonth toMonth:toMonth];
    XCTAssertEqual(components5.year, 3);
    XCTAssertEqual(components5.month, 4);
    XCTAssertEqual(components5.day, 0);
    XCTAssertEqual(components5.hour, 0);
    XCTAssertEqual(components5.minute, 0);
    XCTAssertEqual(components5.second, 0);
}

@end
