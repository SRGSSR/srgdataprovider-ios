//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface SubdivisionTestCase : DataProviderBaseTestCase

@end

@implementation SubdivisionTestCase

- (void)testDisjointNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @40000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @5000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 5000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testDisjointBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                          @{ @"id" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10000,
                                             @"markOut" : @20000,
                                             @"duration" : @10000,
                                             @"blockReason" : @"LEGAL" },
                                          
                                          @{ @"id" : @"B",
                                             @"position" : @1,
                                             @"markIn" : @40000,
                                             @"markOut" : @45000,
                                             @"duration" : @5000,
                                             @"blockReason" : @"GEOBLOCK" }
                                          ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 5000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                          @{ @"id" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10000,
                                             @"markOut" : @20000,
                                             @"duration" : @10000 },
                                          
                                          @{ @"id" : @"B",
                                             @"position" : @1,
                                             @"markIn" : @15000,
                                             @"markOut" : @35000,
                                             @"duration" : @20000 }
                                          ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testOverlappingNormalAndBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingBlockedAndNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 15000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testOverlappingBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testNestedNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"A");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"A");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"A");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonLegal);
}

- (void)testNestedNormalSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonLegal);
}

- (void)testIdenticalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
}

- (void)testNeighboringSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @25000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 25000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testNoSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 0);
}

- (void)testInvalidSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @10000,
                                                 @"duration" : @0 },
                                              
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @60000,
                                                 @"markOut" : @10000,
                                                 @"duration" : @50000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 0);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @50000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"id" : @"C",
                                                 @"position" : @2,
                                                 @"markIn" : @60000,
                                                 @"markOut" : @90000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 50000);
    XCTAssertEqual(segment1.duration, 30000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"C");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 60000);
    XCTAssertEqual(segment2.markOut, 90000);
    XCTAssertEqual(segment2.duration, 30000);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonNone);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20000,
                                                 @"markOut" : @70000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"C",
                                                 @"position" : @2,
                                                 @"markIn" : @30000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"id" : @"D",
                                                 @"position" : @3,
                                                 @"markIn" : @60000,
                                                 @"markOut" : @90000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 5);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 30000);
    XCTAssertEqual(segment1.duration, 10000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"C");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 30000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 30000);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonCommercial);
    
    SRGSubdivision *segment3 = segments[3];
    XCTAssertEqual(segment3.uid, @"B");
    XCTAssertEqual(segment3.position, 3);
    XCTAssertEqual(segment3.markIn, 60000);
    XCTAssertEqual(segment3.markOut, 70000);
    XCTAssertEqual(segment3.duration, 10000);
    XCTAssertEqual(segment3.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment4 = segments[4];
    XCTAssertEqual(segment4.uid, @"D");
    XCTAssertEqual(segment4.position, 4);
    XCTAssertEqual(segment4.markIn, 70000);
    XCTAssertEqual(segment4.markOut, 90000);
    XCTAssertEqual(segment4.duration, 20000);
    XCTAssertEqual(segment4.blockingReason, SRGBlockingReasonNone);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario3
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @30000,
                                                 @"duration" : @20000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @30000,
                                                 @"markOut" : @50000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"C",
                                                 @"position" : @2,
                                                 @"markIn" : @45000,
                                                 @"markOut" : @70000,
                                                 @"duration" : @25000,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"id" : @"D",
                                                 @"position" : @3,
                                                 @"markIn" : @65000,
                                                 @"markOut" : @80000,
                                                 @"duration" : @15000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 4);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 30000);
    XCTAssertEqual(segment0.duration, 20000);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 30000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 15000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"C");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 45000);
    XCTAssertEqual(segment2.markOut, 70000);
    XCTAssertEqual(segment2.duration, 25000);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonCommercial);
    
    SRGSubdivision *segment3 = segments[3];
    XCTAssertEqual(segment3.uid, @"D");
    XCTAssertEqual(segment3.position, 3);
    XCTAssertEqual(segment3.markIn, 70000);
    XCTAssertEqual(segment3.markOut, 80000);
    XCTAssertEqual(segment3.duration, 10000);
    XCTAssertEqual(segment3.blockingReason, SRGBlockingReasonNone);
}

- (void)testRelevantSubdivisions
{
    // After cut, a subdivision smaller than 1 second results but is discarded for this reason
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10500,
                                                 @"markOut" : @30000,
                                                 @"duration" : @19500,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10500);
    XCTAssertEqual(segment0.markOut, 30000);
    XCTAssertEqual(segment0.duration, 19500);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 30000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 30000);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

@end
