//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

static NSURL *ServiceTestURL(void)
{
    return [NSURL URLWithString:@"http://il.srgssr.ch"];
}

@interface ChapterTestCase : XCTestCase

@end

@implementation ChapterTestCase

- (void)testResourcesForVideoOnDemand
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    [[dataProvider videoMediaCompositionWithUid:@"9116567" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 4);
        XCTAssertEqual(mainChapter.playableResources.count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHLS].count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHDS].count, 2);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodHLS);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testResourcesForVideoLivestream
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    [[dataProvider videoMediaCompositionWithUid:@"3608506" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 4);
        XCTAssertEqual(mainChapter.playableResources.count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHLS].count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHDS].count, 2);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodHLS);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testResourcesForAudioOnDemand
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    [[dataProvider audioMediaCompositionWithUid:@"9098092" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 2);
        XCTAssertEqual(mainChapter.playableResources.count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodRTMP].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodProgressive].count, 1);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodProgressive);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testResourcesForAudioLivestream
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    [[dataProvider audioMediaCompositionWithUid:@"3262320" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 4);
        XCTAssertEqual(mainChapter.playableResources.count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHLS].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHDS].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodRTMP].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodProgressive].count, 1);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodHLS);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

@end
