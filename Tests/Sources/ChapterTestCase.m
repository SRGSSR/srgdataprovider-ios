//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <libextobjc/libextobjc.h>
#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

static NSURL *ServiceTestURL(void)
{
    return SRGIntegrationLayerProductionServiceURL();
}

@interface ChapterTestCase : XCTestCase

@end

@implementation ChapterTestCase

- (void)testResourcesForVideoOnDemand
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL()];
    [[dataProvider mediaCompositionForURN:@"urn:rts:video:9116567" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 4);
        XCTAssertEqual(mainChapter.playableResources.count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHLS].count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHDS].count, 2);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodHLS);
        XCTAssertEqual(mainChapter.recommendedSubtitleFormat, SRGSubtitleFormatVTT);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testResourcesForVideoLivestream
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL()];
    [[dataProvider mediaCompositionForURN:@"urn:rts:video:1967124" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 4);
        XCTAssertEqual(mainChapter.playableResources.count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHLS].count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHDS].count, 2);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodHLS);
        XCTAssertEqual(mainChapter.recommendedSubtitleFormat, SRGSubtitleFormatNone);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testResourcesForAudioOnDemand
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL()];
    [[dataProvider mediaCompositionForURN:@"urn:rts:audio:9098092" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 2);
        XCTAssertEqual(mainChapter.playableResources.count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodRTMP].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodProgressive].count, 1);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodProgressive);
        XCTAssertEqual(mainChapter.recommendedSubtitleFormat, SRGSubtitleFormatNone);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testResourcesForAudioLivestream
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL()];
    [[dataProvider mediaCompositionForURN:@"urn:rts:audio:3262320" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.resources.count, 4);
        XCTAssertEqual(mainChapter.playableResources.count, 2);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHLS].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodHDS].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodRTMP].count, 1);
        XCTAssertEqual([mainChapter resourcesForStreamingMethod:SRGStreamingMethodProgressive].count, 1);
        XCTAssertEqual(mainChapter.recommendedStreamingMethod, SRGStreamingMethodHLS);
        XCTAssertEqual(mainChapter.recommendedSubtitleFormat, SRGSubtitleFormatNone);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

- (void)testMarkInMarkOutForVideoOnDemand
{
    __block NSTimeInterval markIn = 0;
    __block NSTimeInterval markOut = 0;
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Ready to play"];
    
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:ServiceTestURL()];
    [[dataProvider mediaCompositionForURN:@"urn:rts:video:9116567" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertNotEqual(mainChapter.segments.count, 0);
        
        SRGSegment *firstSegment = mainChapter.segments.firstObject;
        markIn = firstSegment.markIn;
        markOut = firstSegment.markOut;
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Ready to play"];
    
    [[dataProvider mediaCompositionForURN:@"urn:rts:video:9116567" standalone:YES withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGChapter *mainChapter = mediaComposition.mainChapter;
        XCTAssertEqual(mainChapter.segments.count, 0);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, contentType), @(SRGContentTypeClip)];
        SRGChapter *firstClipChapter = [mediaComposition.chapters filteredArrayUsingPredicate:predicate].firstObject;
        XCTAssertEqualObjects(firstClipChapter.fullLengthURN, mainChapter.URN);
        XCTAssertEqual(firstClipChapter.fullLengthMarkIn, markIn);
        XCTAssertEqual(firstClipChapter.fullLengthMarkOut, markOut);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

@end
