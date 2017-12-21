//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface SubdivisionTestCase : DataProviderBaseTestCase

@end

@implementation SubdivisionTestCase

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
