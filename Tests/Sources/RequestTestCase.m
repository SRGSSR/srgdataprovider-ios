//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

#import "SRGRequest+Private.h"

@interface RequestTestCase : DataProviderBaseTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RequestTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testConstruction
{
    // Default page size
    SRGFirstPageRequest *request1 = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }];
    XCTAssertFalse(request1.running);
    XCTAssertEqual(request1.page.number, 0);
    XCTAssertEqual(request1.page.size, SRGPageDefaultSize);
    
    // Specific page size
    SRGFirstPageRequest *request2 = [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] requestWithPageSize:10];
    XCTAssertFalse(request2.running);
    XCTAssertEqual(request2.page.number, 0);
    XCTAssertEqual(request2.page.size, 10);
    
    // Override with nil page
    __block SRGPageRequest *request3 = [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] requestWithPage:nil];
    XCTAssertFalse(request3.running);
    XCTAssertEqual(request3.page.number, 0);
    XCTAssertEqual(request3.page.size, SRGPageDefaultSize);
    
    // Incorrect page size
    SRGFirstPageRequest *request4 = [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] requestWithPageSize:0];
    XCTAssertFalse(request4.running);
    XCTAssertEqual(request4.page.number, 0);
    XCTAssertEqual(request4.page.size, 1);
    
    // Over maximum page size
    SRGFirstPageRequest *request5 = [[self.dataProvider tvEditorialMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] requestWithPageSize:101];
    XCTAssertFalse(request5.running);
    XCTAssertEqual(request5.page.number, 0);
    XCTAssertEqual(request5.page.size, 100);
    
    // Override with page size, twice
    SRGFirstPageRequest *request6 = [[[self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] requestWithPageSize:18] requestWithPageSize:3];
    XCTAssertFalse(request6.running);
    XCTAssertEqual(request6.page.number, 0);
    XCTAssertEqual(request6.page.size, 3);
    XCTAssertNotEqual(request6.page.size, 18);
}

// Use autorelease pools to force pool drain before testing weak variables (otherwise objects might have been added to
// a pool by ARC depending on how they are used, and might therefore still be alive before a pool is drained)
- (void)testDeallocation
{
    // Non-resumed requests are deallocated when not used
    __weak SRGRequest *request1;
    @autoreleasepool {
        request1 = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
            XCTFail(@"Must not be called since the request has not been resumed");
        }];
    }
    XCTAssertNil(request1);
    
    // Resumed requests are self-retained during their lifetime
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request finished"];
    
    __block SRGRequest *request3;
    @autoreleasepool {
        request3 = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
            // Release the local strong reference
            request3 = nil;
            [expectation3 fulfill];
        }];
        [request3 resume];
    }
    XCTAssertNotNil(request3);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertNil(request3);
}

- (void)testCancelOnProviderDeallocation
{
    [self expectationForElapsedTimeInterval:3. withHandler:nil];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGDataProvider *dataProvider;
    @autoreleasepool {
        dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
        SRGRequest *request = [dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
            XCTFail(@"Must not be called since the request must be cancelled if the associated provider was deallocated");
        }];
        [request resume];
    }
#pragma clang diagnostic pop
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testStatus
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    __block SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // The request is considered running until after the completion block has been executed
        XCTAssertTrue(request.running);
        
        [expectation fulfill];
    }];
    XCTAssertFalse(request.running);
    
    [request resume];
    XCTAssertTrue(request.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request.running);
}

- (void)testPageInformation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    __block SRGFirstPageRequest *request = [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(page.number, 0);
        XCTAssertEqual(page.size, 5);
        
        XCTAssertEqual(request.page.number, 0);
        XCTAssertEqual(request.page.size, 5);
        
        [expectation fulfill];
    }] requestWithPageSize:5];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, 5);
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testSupportedUnlimitedPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    __block SRGFirstPageRequest *request = [[self.dataProvider tvShowsForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] requestWithPageSize:SRGPageUnlimitedSize];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, SRGPageUnlimitedSize);
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testUnsupporteUnlimitedPageSize
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    __block SRGFirstPageRequest *request = [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] requestWithPageSize:SRGPageUnlimitedSize];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, SRGPageUnlimitedSize);
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testRunningKVO
{
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    
    [self keyValueObservingExpectationForObject:request keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertEqual(change[NSKeyValueChangeNewKey], @YES);
        return YES;
    }];
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testMultipleResumes
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    SRGRequest *request = [self.dataProvider mediaCompositionForURN:@"bad_URN" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testReuse
{
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    
    // Wait until the request is not running anymore
    [self keyValueObservingExpectationForObject:request keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    // Restart it
    [self keyValueObservingExpectationForObject:request keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testReuseAfterCancel
{
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    
    // Wait until the request is not running anymore
    [self keyValueObservingExpectationForObject:request keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    [request resume];
    [request cancel];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    // Restart it
    [self keyValueObservingExpectationForObject:request keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testHTTPError
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    SRGRequest *request = [self.dataProvider mediaCompositionForURN:@"bad_URN" standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNil(mediaComposition);
        XCTAssertEqualObjects(error.domain, SRGDataProviderErrorDomain);
        XCTAssertEqual(error.code, SRGDataProviderErrorHTTP);
        
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request.running);
}

- (void)testCancellation
{
    [self expectationForElapsedTimeInterval:3. withHandler:nil];
    
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTFail(@"Completion block must not be called");
    }];
    
    [request resume];
    XCTAssertTrue(request.running);
    
    [request cancel];
    XCTAssertFalse(request.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request.running);
}

- (void)testNestedRequests
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Test nested requests (self-retained)
    SRGRequest *request1 = [self.dataProvider tvEditorialMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        
        SRGMedia *firstMedia = medias.firstObject;
        SRGRequest *request2 = [self.dataProvider mediaCompositionForURN:firstMedia.URN standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
            XCTAssertNotNil(mediaComposition);
            XCTAssertNil(error);
            
            [expectation fulfill];
        }];
        [request2 resume];
    }];
    [request1 resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testPageSizeOverrideTwice
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Use a small page size to be sure we get three elements in the result
    // Be sure to have only the latest pageSize set to the request.
    __block SRGRequest *request = [[[self.dataProvider tvEditorialMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotEqual(medias.count, 18);
        XCTAssertEqual(medias.count, 3);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }] requestWithPageSize:18] requestWithPageSize:3];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testPages
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Use a small page size to be sure we get two full pages of results (and more to come)
    __block SRGFirstPageRequest *request = [[self.dataProvider tvEditorialMediasForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        
        if (page.number == 0 && nextPage) {
            [[request requestWithPage:nextPage] resume];
        }
        else if (page.number == 1) {
            [expectation fulfill];
        }
        else {
            XCTFail(@"Only first two pages are expected");
        }
    }] requestWithPageSize:2];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testNextPageRequestConsistency
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    self.dataProvider.globalHeaders = @{ @"Test-Header" : @"Test-Value" };
    
    __block SRGFirstPageRequest *request = [self.dataProvider latestMediasForTopicWithURN:@"urn:swi:topic:tv:1" completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        
        NSURLRequest *nextPageURLRequest = [request requestWithPage:nextPage].URLRequest;
        XCTAssertEqualObjects(self.dataProvider.serviceURL.host, nextPageURLRequest.URL.host);
        XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testNextPageRequestConsistencyWithCustomServiceURL
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSURL *serviceURL = [NSURL URLWithString:@"http://intlayer.production.srf.ch"];
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL];
    dataProvider.globalHeaders = @{ @"Test-Header" : @"Test-Value" };
    
    __block SRGFirstPageRequest *request = [dataProvider latestMediasForTopicWithURN:@"urn:swi:topic:tv:1" completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
        
        NSURLRequest *nextPageURLRequest = [request requestWithPage:nextPage].URLRequest;
        XCTAssertEqualObjects(serviceURL.host, nextPageURLRequest.URL.host);
        XCTAssertEqualObjects([nextPageURLRequest valueForHTTPHeaderField:@"Test-Header"], @"Test-Value");
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testNormalNetworkActivity
{
    NSMutableArray<NSNumber *> *states = [NSMutableArray array];
    [SRGRequest enableNetworkActivityManagementWithHandler:^(BOOL active) {
        [states addObject:@(active)];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    NSArray<NSNumber *> *expectedStates = @[@NO, @YES, @NO];
    XCTAssertEqualObjects(states, expectedStates);
}

- (void)testEnableNetworkActivityWhenActive
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    
    NSMutableArray<NSNumber *> *states = [NSMutableArray array];
    [SRGRequest enableNetworkActivityManagementWithHandler:^(BOOL active) {
        [states addObject:@(active)];
    }];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    NSArray<NSNumber *> *expectedStates = @[@YES, @NO];
    XCTAssertEqualObjects(states, expectedStates);
}

- (void)testDisableNetworkActivity
{
    NSMutableArray<NSNumber *> *states = [NSMutableArray array];
    [SRGRequest enableNetworkActivityManagementWithHandler:^(BOOL active) {
        [states addObject:@(active)];
    }];
    
    [SRGRequest disableNetworkActivityManagement];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    NSArray<NSNumber *> *expectedStates = @[@NO, @NO];
    XCTAssertEqualObjects(states, expectedStates);
}

- (void)testDisableNetworkActivityWhenActive
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSMutableArray<NSNumber *> *states = [NSMutableArray array];
    [SRGRequest enableNetworkActivityManagementWithHandler:^(BOOL active) {
        [states addObject:@(active)];
    }];
    
    SRGRequest *request = [self.dataProvider tvLatestEpisodesForVendor:SRGVendorSWI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    
    [SRGRequest disableNetworkActivityManagement];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    NSArray<NSNumber *> *expectedStates = @[@NO, @YES, @NO];
    XCTAssertEqualObjects(states, expectedStates);
}

@end
