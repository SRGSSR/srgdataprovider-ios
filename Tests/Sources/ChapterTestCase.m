//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface ChapterTestCase : DataProviderBaseTestCase

@end

@implementation ChapterTestCase

// Test:
//   - Two disjoint subdivisions (OK)
//   - Two disjoint blocked subdivisions (OK)
//   - Two overlapping subdivisions (OK)

//   - Subdivision overlapping with blocked one (OK)
//   - Blocked subdivion overlapping with normal one (OK)
//   - Two overlapping blocked subdivisions (OK)

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

- (void)testDisjointNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"title" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10 },
                                              
                                              @{ @"title" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @40,
                                                 @"markOut" : @45,
                                                 @"duration" : @5 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.title, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.title, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40);
    XCTAssertEqual(segment1.markOut, 45);
    XCTAssertEqual(segment1.duration, 5);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testDisjointBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                          @{ @"title" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10,
                                             @"markOut" : @20,
                                             @"duration" : @10,
                                             @"blockReason" : @"LEGAL" },
                                          
                                          @{ @"title" : @"B",
                                             @"position" : @1,
                                             @"markIn" : @40,
                                             @"markOut" : @45,
                                             @"duration" : @5,
                                             @"blockReason" : @"GEOBLOCK" }
                                          ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.title, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.title, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40);
    XCTAssertEqual(segment1.markOut, 45);
    XCTAssertEqual(segment1.duration, 5);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                          @{ @"title" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10,
                                             @"markOut" : @20,
                                             @"duration" : @10 },
                                          
                                          @{ @"title" : @"B",
                                             @"position" : @1,
                                             @"markIn" : @15,
                                             @"markOut" : @35,
                                             @"duration" : @20 }
                                          ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.title, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 15);
    XCTAssertEqual(segment0.duration, 5);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.title, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15);
    XCTAssertEqual(segment1.markOut, 35);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testOverlappingNormalAndBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"title" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10 },
                                              
                                              @{ @"title" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @15,
                                                 @"markOut" : @35,
                                                 @"duration" : @20,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.title, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 15);
    XCTAssertEqual(segment0.duration, 5);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.title, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15);
    XCTAssertEqual(segment1.markOut, 35);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingBlockedAndNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"title" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"title" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @15,
                                                 @"markOut" : @35,
                                                 @"duration" : @20 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.title, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.title, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 35);
    XCTAssertEqual(segment1.duration, 15);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testOverlappingBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"title" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"title" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @15,
                                                 @"markOut" : @35,
                                                 @"duration" : @20,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.title, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 15);
    XCTAssertEqual(segment0.duration, 5);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.title, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15);
    XCTAssertEqual(segment1.markOut, 35);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

@end
