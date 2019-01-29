//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface DataProviderTestCase : DataProviderBaseTestCase

@end

@implementation DataProviderTestCase

#pragma mark Tests

- (void)testCreation
{
    NSURL *serviceURL = SRGIntegrationLayerProductionServiceURL();
    
    SRGDataProvider *dataProvider1 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL];
    XCTAssertEqualObjects(dataProvider1.serviceURL, SRGIntegrationLayerProductionServiceURL());
    
    XCTAssertNil(SRGDataProvider.currentDataProvider);
    SRGDataProvider.currentDataProvider = dataProvider1;
    XCTAssertEqualObjects(SRGDataProvider.currentDataProvider, dataProvider1);
    
    SRGDataProvider *dataProvider2 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL];
    XCTAssertNotNil(dataProvider2);
    SRGDataProvider.currentDataProvider = dataProvider2;
    XCTAssertEqualObjects(SRGDataProvider.currentDataProvider, dataProvider2);
}

- (void)testDeallocation
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    XCTAssertNil(dataProvider);
#pragma clang diagnostic pop
}

- (void)testDefaultMainThreadCompletion
{
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 finished"];
    
    [[dataProvider tvChannelsForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 finished"];
    
    [[dataProvider tvLatestMediasForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        [expectation2 fulfill];
    }] resume];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 finished"];
    
    [[dataProvider latestEpisodesForShowWithURN:@"urn:rts:show:tv:6454706" maximumPublicationMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testBackgroundThreadCompletion
{
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 finished"];
    
    [[[dataProvider tvChannelsForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertFalse(NSThread.isMainThread);
        [expectation1 fulfill];
    }] requestWithOptions:SRGNetworkRequestBackgroundThreadCompletionEnabled] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 finished"];
    
    [[[dataProvider tvLatestMediasForVendor:SRGVendorRTS withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertFalse(NSThread.isMainThread);
        [expectation2 fulfill];
    }] requestWithOptions:SRGNetworkRequestBackgroundThreadCompletionEnabled] resume];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 finished"];
    
    [[[dataProvider latestEpisodesForShowWithURN:@"urn:rts:show:tv:6454706" maximumPublicationMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertFalse(NSThread.isMainThread);
        [expectation3 fulfill];
    }] requestWithOptions:SRGNetworkRequestBackgroundThreadCompletionEnabled] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
