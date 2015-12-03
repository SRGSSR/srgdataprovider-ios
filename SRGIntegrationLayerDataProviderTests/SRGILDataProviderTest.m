//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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

@end
