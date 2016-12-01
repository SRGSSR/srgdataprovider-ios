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
    NSURL *serviceURL = [NSURL URLWithString:@"https://il-test.srgssr.ch"];
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSWI];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testConstruction
{
    // Default page size
    SRGRequest *request1 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(page.number, 0);
        XCTAssertEqual(page.size, SRGPageDefaultSize);
    }];
    XCTAssertFalse(request1.running);
    XCTAssertEqual(request1.page.number, 0);
    XCTAssertEqual(request1.page.size, SRGPageDefaultSize);
    
    // Specific page size
    SRGRequest *request2 = [[self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(page.number, 0);
        XCTAssertEqual(page.size, 10);
    }] withPageSize:10];
    XCTAssertFalse(request2.running);
    XCTAssertEqual(request2.page.number, 0);
    XCTAssertEqual(request2.page.size, 10);
    
    // Override with nil page
    __block SRGRequest *request3 = [[self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(page.number, 0);
        XCTAssertEqual(page.size, SRGPageDefaultSize);
    }] atPage:nil];
    XCTAssertFalse(request3.running);
    XCTAssertEqual(request3.page.number, 0);
    XCTAssertEqual(request3.page.size, SRGPageDefaultSize);
    
    // Incorrect page size
    SRGRequest *request4 = [[self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertEqual(page.number, 0);
        XCTAssertEqual(page.size, 1);
    }] withPageSize:0];
    XCTAssertFalse(request4.running);
    XCTAssertEqual(request4.page.number, 0);
    XCTAssertEqual(request4.page.size, 1);
}

- (void)testStatus
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request finished"];
    
    __block SRGRequest *request = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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

- (void)testRunningKVO
{
    SRGRequest *request = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider mediaCompositionForVideoWithUid:@"bad_id" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [request resume];
    [request resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testReuse
{
    SRGRequest *request = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    SRGRequest *request = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider mediaCompositionForVideoWithUid:@"bad_id" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTFail(@"Completion block must not be called");
    }];
    
    [request resume];
    XCTAssertTrue(request.running);
    
    [request cancel];
    XCTAssertFalse(request.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request.running);
}

- (void)testPages
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    // Use a small page size to be sure we get two full pages of results (and more to come)
    __block SRGRequest *request = [[self.dataProvider editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
