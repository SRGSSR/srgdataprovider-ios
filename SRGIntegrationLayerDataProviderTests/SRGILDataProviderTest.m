//
//  SRGILDataProviderTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 11/06/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SRGILDataProvider.h"

@interface SRGILDataProviderTest : XCTestCase

@end

@implementation SRGILDataProviderTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProviderInvalidInits
{
    XCTAssertThrows([[SRGILDataProvider alloc] init], @"You must use the designated initializer");
    XCTAssertThrows([[SRGILDataProvider alloc] initWithBusinessUnit:@"toto"], @"You must provide a valid BU value");
}

- (void)testProviderValidInits
{
    XCTAssertNoThrow([[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"]);
    SRGILDataProvider *p = ([[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"]);
    XCTAssertEqualObjects(p.businessUnit, @"srf");
    XCTAssertEqual(p.ongoingFetchCount, 0);
}

- (void)testProviderFetchDatesUponInit
{
    SRGILDataProvider *p = ([[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"]);
    for (NSInteger i = SRGILFetchListEnumBegin; i < SRGILFetchListEnumEnd; i ++) {
        XCTAssertNil([p fetchDateForIndex:i], @"Date must be nil if no data were fetched.");
    }
}

- (void)testProviderFetchPathsUponInit
{
    SRGILDataProvider *p = ([[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"]);
    for (NSInteger i = SRGILFetchListEnumBegin; i < SRGILFetchListEnumEnd; i ++) {
        XCTAssertTrue([p isFetchPathValidForIndex:i], @"Fetch path must be valid if no data were fetched.");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
