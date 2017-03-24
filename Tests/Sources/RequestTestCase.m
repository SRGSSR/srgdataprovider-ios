//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

@interface RequestTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RequestTestCase

#pragma mark Helpers

- (XCTestExpectation *)expectationForElapsedTimeInterval:(NSTimeInterval)timeInterval withHandler:(void (^)(void))handler
{
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Wait for %@ seconds", @(timeInterval)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
        handler ? handler() : nil;
    });
    return expectation;
}

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSWI];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testConstruction
{
    // Default page size
    SRGRequest *request1 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }];
    XCTAssertFalse(request1.running);
    XCTAssertEqual(request1.page.number, 0);
    XCTAssertEqual(request1.page.size, SRGPageDefaultSize);
    
    // Specific page size
    SRGRequest *request2 = [[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] withPageSize:10];
    XCTAssertFalse(request2.running);
    XCTAssertEqual(request2.page.number, 0);
    XCTAssertEqual(request2.page.size, 10);
    
    // Override with nil page
    __block SRGRequest *request3 = [[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] atPage:nil];
    XCTAssertFalse(request3.running);
    XCTAssertEqual(request3.page.number, 0);
    XCTAssertEqual(request3.page.size, SRGPageDefaultSize);
    
    // Override with page size, then nil page
    __block SRGRequest *request4 = [[[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] withPageSize:15] atPage:nil];
    XCTAssertFalse(request4.running);
    XCTAssertEqual(request4.page.number, 0);
    XCTAssertEqual(request4.page.size, 15);
    
    // Incorrect page size
    SRGRequest *request5 = [[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] withPageSize:0];
    XCTAssertFalse(request5.running);
    XCTAssertEqual(request5.page.number, 0);
    XCTAssertEqual(request5.page.size, 1);
    
    // Override with page size, twice
    SRGRequest *request6 = [[[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing, the request isn't run
    }] withPageSize:18] withPageSize:3];
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
        request1 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
            XCTFail(@"Must not be called since the request has not been resumed");
        }];
    }
    XCTAssertNil(request1);
    
    // Resumed requests are self-retained during their lifetime
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request finished"];
    
    __block SRGRequest *request3;
    @autoreleasepool {
        request3 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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

- (void)testStatus
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    __block SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    __block SRGRequest *request = [[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(page.number, 0);
        XCTAssertEqual(page.size, 5);
        
        XCTAssertEqual(request.page.number, 0);
        XCTAssertEqual(request.page.size, 5);
        
        [expectation fulfill];
    }] withPageSize:5];
    
    XCTAssertEqual(request.page.number, 0);
    XCTAssertEqual(request.page.size, 5);
    
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testRunningKVO
{
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider tvMediaCompositionWithUid:@"bad_id" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testReuse
{
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider tvMediaCompositionWithUid:@"bad_id" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTFail(@"Completion block must not be called");
    }];
    
    [request resume];
    XCTAssertTrue(request.running);
    
    [request cancel];
    XCTAssertFalse(request.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request.running);
}

- (void)testPageSizeOverrideTwice
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Use a small page size to be sure we get three elements in the result
    // Be sure to have only the latest pageSize set to the request.
    __block SRGRequest *request = [[[self.dataProvider tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotEqual(medias.count, 18);
        XCTAssertEqual(medias.count, 3);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }] withPageSize:18] withPageSize:3];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testPages
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Use a small page size to be sure we get two full pages of results (and more to come)
    __block SRGRequest *request = [[self.dataProvider tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        XCTAssertNotNil(nextPage);
      
        if (page.number == 0 && nextPage) {
            [[request atPage:nextPage] resume];
        }
        else if (page.number == 1) {
            [expectation fulfill];
        }
        else {
            XCTFail(@"Only first two pages are expected");
        }
    }] withPageSize:2];
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// TODO: Test what happens with page size added to a request not supporting it, or to page size chained after atPage:. Document
// and maybe add warnings (e.g. topics)

@end
