//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface SegmentTestCase : DataProviderBaseTestCase

@end

@implementation SegmentTestCase

- (void)testDisjointNormalSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @40000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @5000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 5000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testDisjointBlockedSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @40000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @5000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 5000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingNormalSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testOverlappingNormalAndBlockedSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingBlockedAndNormalSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 15000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testOverlappingBlockedSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testNestedNormalSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN, @"A");
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSegment *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN, @"A");
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSegment *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN, @"A");
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
}

- (void)testNestedNormalSegmentsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"A");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSegmentsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"A");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSegmentsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSegmentsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"A");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
}

- (void)testIdenticalSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNeighboringSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @25000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 25000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNoSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 0);
}

- (void)testInvalidSegments
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @10000,
                                                 @"duration" : @0 },
                                              
                                              @{ @"urn" : @"A",
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
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @50000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"urn" : @"C",
                                                 @"markIn" : @60000,
                                                 @"markOut" : @90000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 50000);
    XCTAssertEqual(segment1.duration, 30000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN, @"C");
    XCTAssertEqual(segment2.markIn, 60000);
    XCTAssertEqual(segment2.markOut, 90000);
    XCTAssertEqual(segment2.duration, 30000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @70000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"C",
                                                 @"markIn" : @30000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"urn" : @"D",
                                                 @"markIn" : @60000,
                                                 @"markOut" : @90000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 5);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 30000);
    XCTAssertEqual(segment1.duration, 10000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSegment *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN, @"C");
    XCTAssertEqual(segment2.markIn, 30000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 30000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonCommercial);
    
    SRGSegment *segment3 = segments[3];
    XCTAssertEqualObjects(segment3.URN, @"B");
    XCTAssertEqual(segment3.markIn, 60000);
    XCTAssertEqual(segment3.markOut, 70000);
    XCTAssertEqual(segment3.duration, 10000);
    XCTAssertEqual([segment3 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSegment *segment4 = segments[4];
    XCTAssertEqualObjects(segment4.URN, @"D");
    XCTAssertEqual(segment4.markIn, 70000);
    XCTAssertEqual(segment4.markOut, 90000);
    XCTAssertEqual(segment4.duration, 20000);
    XCTAssertEqual([segment4 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

// See https://github.com/SRGSSR/srgletterbox-ios/issues/75
- (void)testSRFScenario3
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @30000,
                                                 @"duration" : @20000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @30000,
                                                 @"markOut" : @50000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"C",
                                                 @"markIn" : @45000,
                                                 @"markOut" : @70000,
                                                 @"duration" : @25000,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"urn" : @"D",
                                                 @"markIn" : @65000,
                                                 @"markOut" : @80000,
                                                 @"duration" : @15000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 4);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 30000);
    XCTAssertEqual(segment0.duration, 20000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"B");
    XCTAssertEqual(segment1.markIn, 30000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 15000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSegment *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN, @"C");
    XCTAssertEqual(segment2.markIn, 45000);
    XCTAssertEqual(segment2.markOut, 70000);
    XCTAssertEqual(segment2.duration, 25000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonCommercial);
    
    SRGSegment *segment3 = segments[3];
    XCTAssertEqualObjects(segment3.URN, @"D");
    XCTAssertEqual(segment3.markIn, 70000);
    XCTAssertEqual(segment3.markOut, 80000);
    XCTAssertEqual(segment3.duration, 10000);
    XCTAssertEqual([segment3 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testRelevantSegments
{
    // After cut, a segment smaller than 1 second results but is discarded for this reason
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"B",
                                                 @"markIn" : @10500,
                                                 @"markOut" : @30000,
                                                 @"duration" : @19500,
                                                 @"blockReason" : @"GEOBLOCK" }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSegment *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN, @"B");
    XCTAssertEqual(segment0.markIn, 10500);
    XCTAssertEqual(segment0.markOut, 30000);
    XCTAssertEqual(segment0.duration, 19500);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSegment *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN, @"A");
    XCTAssertEqual(segment1.markIn, 30000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 30000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

@end
