//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface ChapterTestCase : DataProviderBaseTestCase

@end

@implementation ChapterTestCase

- (void)testDisjointNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10 },
                                              
                                              @{ @"id" : @"B",
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
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
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
                                          @{ @"id" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10,
                                             @"markOut" : @20,
                                             @"duration" : @10,
                                             @"blockReason" : @"LEGAL" },
                                          
                                          @{ @"id" : @"B",
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
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
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
                                          @{ @"id" : @"A",
                                             @"position" : @0,
                                             @"markIn" : @10,
                                             @"markOut" : @20,
                                             @"duration" : @10 },
                                          
                                          @{ @"id" : @"B",
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
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 15);
    XCTAssertEqual(segment0.duration, 5);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
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
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10 },
                                              
                                              @{ @"id" : @"B",
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
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 15);
    XCTAssertEqual(segment0.duration, 5);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
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
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"id" : @"B",
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
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
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
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"B",
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
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 15);
    XCTAssertEqual(segment0.duration, 5);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 15);
    XCTAssertEqual(segment1.markOut, 35);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testNestedNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @40,
                                                 @"duration" : @20 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 40);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"A");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 40);
    XCTAssertEqual(segment2.markOut, 60);
    XCTAssertEqual(segment2.duration, 20);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @40,
                                                 @"duration" : @20,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 40);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"A");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 40);
    XCTAssertEqual(segment2.markOut, 60);
    XCTAssertEqual(segment2.duration, 20);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @40,
                                                 @"duration" : @20 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 60);
    XCTAssertEqual(segment0.duration, 50);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @40,
                                                 @"duration" : @20,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 40);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"A");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 40);
    XCTAssertEqual(segment2.markOut, 60);
    XCTAssertEqual(segment2.duration, 20);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonLegal);
}

- (void)testNestedNormalSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10,
                                                 @"markOut" : @40,
                                                 @"duration" : @30 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 40);
    XCTAssertEqual(segment0.duration, 30);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40);
    XCTAssertEqual(segment1.markOut, 60);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10,
                                                 @"markOut" : @40,
                                                 @"duration" : @30,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 40);
    XCTAssertEqual(segment0.duration, 30);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40);
    XCTAssertEqual(segment1.markOut, 60);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10,
                                                 @"markOut" : @40,
                                                 @"duration" : @30 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 60);
    XCTAssertEqual(segment0.duration, 50);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @10,
                                                 @"markOut" : @40,
                                                 @"duration" : @30,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"B");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 40);
    XCTAssertEqual(segment0.duration, 30);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"A");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 40);
    XCTAssertEqual(segment1.markOut, 60);
    XCTAssertEqual(segment1.duration, 20);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonLegal);
}

- (void)testIdenticalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50 },
                                              
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @60,
                                                 @"duration" : @50 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 60);
    XCTAssertEqual(segment0.duration, 50);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
}

- (void)testNeighboringSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @20,
                                                 @"duration" : @10 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @45,
                                                 @"duration" : @25 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 45);
    XCTAssertEqual(segment1.duration, 25);
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
                                                 @"markIn" : @10,
                                                 @"markOut" : @10,
                                                 @"duration" : @0 },
                                              
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @60,
                                                 @"markOut" : @10,
                                                 @"duration" : @50 }
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
                                                 @"markIn" : @10,
                                                 @"markOut" : @40,
                                                 @"duration" : @30 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @50,
                                                 @"duration" : @30 },
                                              
                                              @{ @"id" : @"C",
                                                 @"position" : @2,
                                                 @"markIn" : @60,
                                                 @"markOut" : @90,
                                                 @"duration" : @30 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 50);
    XCTAssertEqual(segment1.duration, 30);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"C");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 60);
    XCTAssertEqual(segment2.markOut, 90);
    XCTAssertEqual(segment2.duration, 30);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonNone);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @40,
                                                 @"duration" : @30 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @20,
                                                 @"markOut" : @70,
                                                 @"duration" : @50,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"C",
                                                 @"position" : @2,
                                                 @"markIn" : @30,
                                                 @"markOut" : @60,
                                                 @"duration" : @30,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"id" : @"D",
                                                 @"position" : @3,
                                                 @"markIn" : @60,
                                                 @"markOut" : @90,
                                                 @"duration" : @30 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 5);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 20);
    XCTAssertEqual(segment0.duration, 10);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 20);
    XCTAssertEqual(segment1.markOut, 30);
    XCTAssertEqual(segment1.duration, 10);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"C");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 30);
    XCTAssertEqual(segment2.markOut, 60);
    XCTAssertEqual(segment2.duration, 30);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonCommercial);
    
    SRGSubdivision *segment3 = segments[3];
    XCTAssertEqual(segment3.uid, @"B");
    XCTAssertEqual(segment3.position, 3);
    XCTAssertEqual(segment3.markIn, 60);
    XCTAssertEqual(segment3.markOut, 70);
    XCTAssertEqual(segment3.duration, 10);
    XCTAssertEqual(segment3.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment4 = segments[4];
    XCTAssertEqual(segment4.uid, @"D");
    XCTAssertEqual(segment4.position, 4);
    XCTAssertEqual(segment4.markIn, 70);
    XCTAssertEqual(segment4.markOut, 90);
    XCTAssertEqual(segment4.duration, 20);
    XCTAssertEqual(segment4.blockingReason, SRGBlockingReasonNone);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario3
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"id" : @"A",
                                                 @"position" : @0,
                                                 @"markIn" : @10,
                                                 @"markOut" : @30,
                                                 @"duration" : @20 },
                                              
                                              @{ @"id" : @"B",
                                                 @"position" : @1,
                                                 @"markIn" : @30,
                                                 @"markOut" : @50,
                                                 @"duration" : @20,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"id" : @"C",
                                                 @"position" : @2,
                                                 @"markIn" : @45,
                                                 @"markOut" : @70,
                                                 @"duration" : @25,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"id" : @"D",
                                                 @"position" : @3,
                                                 @"markIn" : @65,
                                                 @"markOut" : @80,
                                                 @"duration" : @15 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 4);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqual(segment0.uid, @"A");
    XCTAssertEqual(segment0.position, 0);
    XCTAssertEqual(segment0.markIn, 10);
    XCTAssertEqual(segment0.markOut, 30);
    XCTAssertEqual(segment0.duration, 20);
    XCTAssertEqual(segment0.blockingReason, SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqual(segment1.uid, @"B");
    XCTAssertEqual(segment1.position, 1);
    XCTAssertEqual(segment1.markIn, 30);
    XCTAssertEqual(segment1.markOut, 45);
    XCTAssertEqual(segment1.duration, 15);
    XCTAssertEqual(segment1.blockingReason, SRGBlockingReasonLegal);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqual(segment2.uid, @"C");
    XCTAssertEqual(segment2.position, 2);
    XCTAssertEqual(segment2.markIn, 45);
    XCTAssertEqual(segment2.markOut, 70);
    XCTAssertEqual(segment2.duration, 25);
    XCTAssertEqual(segment2.blockingReason, SRGBlockingReasonCommercial);
    
    SRGSubdivision *segment3 = segments[3];
    XCTAssertEqual(segment3.uid, @"D");
    XCTAssertEqual(segment3.position, 3);
    XCTAssertEqual(segment3.markIn, 70);
    XCTAssertEqual(segment3.markOut, 80);
    XCTAssertEqual(segment3.duration, 10);
    XCTAssertEqual(segment3.blockingReason, SRGBlockingReasonNone);
}

@end
