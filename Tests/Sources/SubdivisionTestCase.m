//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface SubdivisionTestCase : DataProviderBaseTestCase

@end

@implementation SubdivisionTestCase

// Test:
//   - Two disjoint subdivisions (OK)
//   - Two disjoint blocked subdivisions
//   - Two overlapping subdivisions

//   - Subdivision overlapping with blocked one
//   - Blocked subdivion overlapping with normal one
//   - Two overlapping subdivisions

//   - Two nested normal subdivisions
//   - Blocked subdivision nested in non-blocked one
//   - Non-blocked subdivision nested in blocked one
//   - Twpo nested blocked subdivisions
//   - Two overlapping suvdivisions with same markin, different durations
//   - Two overlapping suvdivisions with same markout, different durations
//   - Two identical subdivisions

//   - SRF use cases

//   - Empty subdivisions
//   - Incorrect markout
//   - Incorrect duration

- (void)testDisjointSubdivisions
{
    NSError *error = nil;
    NSArray<NSDictionary *> *JSONArray = [NSArray arrayWithObjects:
                                          @{ @"title" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10,
                                             @"markOut" : @20,
                                             @"duration" : @10 },
                                          
                                          @{ @"title" : @"B",
                                             @"position" : @1,
                                             @"markIn" : @40,
                                             @"markOut" : @45,
                                             @"duration" : @5 }, nil];
    NSArray<SRGSubdivision *> *subdivisions = [MTLJSONAdapter modelsOfClass:[SRGSubdivision class] fromJSONArray:JSONArray error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(subdivisions.count, 2);
    
    SRGSubdivision *subdivision0 = subdivisions[0];
    XCTAssertEqual(subdivision0.title, @"A");
    XCTAssertEqual(subdivision0.position, 0);
    XCTAssertEqual(subdivision0.markIn, 10);
    XCTAssertEqual(subdivision0.markOut, 20);
    XCTAssertEqual(subdivision0.duration, 10);
    XCTAssertEqual(subdivision0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *subdivision1 = subdivisions[1];
    XCTAssertEqual(subdivision1.title, @"B");
    XCTAssertEqual(subdivision1.position, 1);
    XCTAssertEqual(subdivision1.markIn, 40);
    XCTAssertEqual(subdivision1.markOut, 45);
    XCTAssertEqual(subdivision1.duration, 5);
    XCTAssertEqual(subdivision1.blockingReason, SRGBlockingReasonNone);
}

@end
