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
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @40000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @5000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 5000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testDisjointBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                          @{ @"urn" : @"urn:rts:video:A",
                                             @"markIn" : @10000,
                                             @"markOut" : @20000,
                                             @"duration" : @10000,
                                             @"blockReason" : @"LEGAL" },
                                          
                                          @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 5000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                          @{ @"urn" : @"urn:rts:video:A",
                                             @"markIn" : @10000,
                                             @"markOut" : @20000,
                                             @"duration" : @10000 },
                                          
                                          @{ @"urn" : @"urn:rts:video:B",
                                             @"markIn" : @15000,
                                             @"markOut" : @35000,
                                             @"duration" : @20000 }
                                          ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testOverlappingNormalAndBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testOverlappingBlockedAndNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @15000,
                                                 @"markOut" : @35000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 15000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testOverlappingBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 15000);
    XCTAssertEqual(segment0.duration, 5000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 15000);
    XCTAssertEqual(segment1.markOut, 35000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testNestedNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN.uid, @"A");
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN.uid, @"A");
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @20000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 40000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN.uid, @"A");
    XCTAssertEqual(segment2.markIn, 40000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 20000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
}

- (void)testNestedNormalSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"A");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedBlockedInNormalSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"A");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNestedNormalInBlockedSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"GEOBLOCK" },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
}

- (void)testNestedBlockedSubdivisionsWithSameMarkIn
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 40000);
    XCTAssertEqual(segment0.duration, 30000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"A");
    XCTAssertEqual(segment1.markIn, 40000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 20000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
}

- (void)testIdenticalSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 1);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"B");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 60000);
    XCTAssertEqual(segment0.duration, 50000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNeighboringSubdivisions
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @20000,
                                                 @"duration" : @10000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @45000,
                                                 @"duration" : @25000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 2);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 25000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
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
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @10000,
                                                 @"duration" : @0 },
                                              
                                              @{ @"urn" : @"urn:rts:video:A",
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
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @50000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:C",
                                                 @"markIn" : @60000,
                                                 @"markOut" : @90000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 3);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 50000);
    XCTAssertEqual(segment1.duration, 30000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN.uid, @"C");
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
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @40000,
                                                 @"duration" : @30000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @20000,
                                                 @"markOut" : @70000,
                                                 @"duration" : @50000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:C",
                                                 @"markIn" : @30000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @30000,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:D",
                                                 @"markIn" : @60000,
                                                 @"markOut" : @90000,
                                                 @"duration" : @30000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 5);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 20000);
    XCTAssertEqual(segment0.duration, 10000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 20000);
    XCTAssertEqual(segment1.markOut, 30000);
    XCTAssertEqual(segment1.duration, 10000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN.uid, @"C");
    XCTAssertEqual(segment2.markIn, 30000);
    XCTAssertEqual(segment2.markOut, 60000);
    XCTAssertEqual(segment2.duration, 30000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonCommercial);
    
    SRGSubdivision *segment3 = segments[3];
    XCTAssertEqualObjects(segment3.URN.uid, @"B");
    XCTAssertEqual(segment3.markIn, 60000);
    XCTAssertEqual(segment3.markOut, 70000);
    XCTAssertEqual(segment3.duration, 10000);
    XCTAssertEqual([segment3 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSubdivision *segment4 = segments[4];
    XCTAssertEqualObjects(segment4.URN.uid, @"D");
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
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @30000,
                                                 @"duration" : @20000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
                                                 @"markIn" : @30000,
                                                 @"markOut" : @50000,
                                                 @"duration" : @20000,
                                                 @"blockReason" : @"LEGAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:C",
                                                 @"markIn" : @45000,
                                                 @"markOut" : @70000,
                                                 @"duration" : @25000,
                                                 @"blockReason" : @"COMMERCIAL" },
                                              
                                              @{ @"urn" : @"urn:rts:video:D",
                                                 @"markIn" : @65000,
                                                 @"markOut" : @80000,
                                                 @"duration" : @15000 }
                                              ] };
    
    SRGChapter *chapter = [MTLJSONAdapter modelOfClass:[SRGChapter class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    NSArray<SRGSegment *> *segments = chapter.segments;
    XCTAssertEqual(segments.count, 4);
    
    SRGSubdivision *segment0 = segments[0];
    XCTAssertEqualObjects(segment0.URN.uid, @"A");
    XCTAssertEqual(segment0.markIn, 10000);
    XCTAssertEqual(segment0.markOut, 30000);
    XCTAssertEqual(segment0.duration, 20000);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"B");
    XCTAssertEqual(segment1.markIn, 30000);
    XCTAssertEqual(segment1.markOut, 45000);
    XCTAssertEqual(segment1.duration, 15000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
    
    SRGSubdivision *segment2 = segments[2];
    XCTAssertEqualObjects(segment2.URN.uid, @"C");
    XCTAssertEqual(segment2.markIn, 45000);
    XCTAssertEqual(segment2.markOut, 70000);
    XCTAssertEqual(segment2.duration, 25000);
    XCTAssertEqual([segment2 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonCommercial);
    
    SRGSubdivision *segment3 = segments[3];
    XCTAssertEqualObjects(segment3.URN.uid, @"D");
    XCTAssertEqual(segment3.markIn, 70000);
    XCTAssertEqual(segment3.markOut, 80000);
    XCTAssertEqual(segment3.duration, 10000);
    XCTAssertEqual([segment3 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testRelevantSubdivisions
{
    // After cut, a subdivision smaller than 1 second results but is discarded for this reason
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"segmentList" : @[
                                              @{ @"urn" : @"urn:rts:video:A",
                                                 @"markIn" : @10000,
                                                 @"markOut" : @60000,
                                                 @"duration" : @50000 },
                                              
                                              @{ @"urn" : @"urn:rts:video:B",
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
    XCTAssertEqualObjects(segment0.URN.uid, @"B");
    XCTAssertEqual(segment0.markIn, 10500);
    XCTAssertEqual(segment0.markOut, 30000);
    XCTAssertEqual(segment0.duration, 19500);
    XCTAssertEqual([segment0 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonGeoblocking);
    
    SRGSubdivision *segment1 = segments[1];
    XCTAssertEqualObjects(segment1.URN.uid, @"A");
    XCTAssertEqual(segment1.markIn, 30000);
    XCTAssertEqual(segment1.markOut, 60000);
    XCTAssertEqual(segment1.duration, 30000);
    XCTAssertEqual([segment1 blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testMediaForSubdivision
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSRF];
    SRGMediaURN *URN = [SRGMediaURN mediaURNWithString:@"urn:srf:video:2c685129-bad8-4ea0-93f5-0d6cff8cb156"];
    [[dataProvider mediaCompositionWithURN:URN chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.chapterURN, URN);
        XCTAssertNil(mediaComposition.segmentURN);
        
        // Derive the chapter media
        SRGMedia *chapterMedia = [mediaComposition mediaForSubdivision:mediaComposition.mainChapter];
        XCTAssertEqualObjects(chapterMedia.URN, URN);
        
        // ... and from a segment copy
        SRGMedia *chapterMediaCopy = [mediaComposition mediaForSubdivision:[mediaComposition.mainChapter copy]];
        XCTAssertEqualObjects(chapterMediaCopy.URN, URN);
        
        // Derive a segment media
        SRGSegment *segment = mediaComposition.mainChapter.segments.firstObject;
        XCTAssertNotNil(segment);
        
        SRGMedia *segmentMedia = [mediaComposition mediaForSubdivision:segment];
        XCTAssertEqualObjects(segmentMedia.URN, segment.URN);
        
        // ... and from a chapter copy
        SRGMedia *segmentMediaCopy = [mediaComposition mediaForSubdivision:[segment copy]];
        XCTAssertEqualObjects(segmentMediaCopy.URN, segment.URN);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediaCompositionForSubdivision
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSRF];
    SRGMediaURN *URN = [SRGMediaURN mediaURNWithString:@"urn:srf:video:2c685129-bad8-4ea0-93f5-0d6cff8cb156"];
    [[dataProvider mediaCompositionWithURN:URN chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.chapterURN, URN);
        XCTAssertNil(mediaComposition.segmentURN);
        
        SRGSegment *segment = mediaComposition.mainChapter.segments.firstObject;
        XCTAssertNotNil(segment);
        
        // Derive a segment media composition
        SRGMediaComposition *segmentMediaComposition = [mediaComposition mediaCompositionForSubdivision:segment];
        XCTAssertEqualObjects(segmentMediaComposition.chapterURN, URN);
        XCTAssertEqualObjects(segmentMediaComposition.segmentURN, segment.URN);
        
        // ... and from a segment copy
        SRGMediaComposition *segmentCopyMediaComposition = [mediaComposition mediaCompositionForSubdivision:[segment copy]];
        XCTAssertEqualObjects(segmentCopyMediaComposition.chapterURN, URN);
        XCTAssertEqualObjects(segmentCopyMediaComposition.segmentURN, segment.URN);
        
        // Derive the chapter media composition, but from the segment media composition. Must obtain the original media composition
        SRGMediaComposition *chapterMediaComposition = [segmentMediaComposition mediaCompositionForSubdivision:segmentMediaComposition.mainChapter];
        XCTAssertEqualObjects(chapterMediaComposition.chapterURN, URN);
        XCTAssertNil(chapterMediaComposition.segmentURN);
        
        // Do the same with a copy
        SRGMediaComposition *chapterCopyMediaComposition = [segmentMediaComposition mediaCompositionForSubdivision:[segmentMediaComposition.mainChapter copy]];
        XCTAssertEqualObjects(chapterCopyMediaComposition.chapterURN, URN);
        XCTAssertNil(chapterCopyMediaComposition.segmentURN);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
