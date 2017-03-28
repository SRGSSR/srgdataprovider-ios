//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface RequestQueueTestCase : DataProviderBaseTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RequestQueueTestCase

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

- (void)testCreation
{
    SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] init];
    XCTAssertFalse(requestQueue.running);
}

- (void)testSingleRequest
{
    __block BOOL requestFinished = NO;
    __block BOOL requestQueueFinished = NO;
    
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];

    XCTestExpectation *requestCompletionExpectation = [self expectationWithDescription:@"Request completed"];

    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertNil(error);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            XCTAssertTrue(requestFinished);
            
            requestQueueFinished = YES;
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertFalse(requestQueueFinished);
        [requestQueue reportError:error];
        
        requestFinished = YES;
        [requestCompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request.running);
    XCTAssertFalse(requestQueue.running);
}

- (void)testEmptyQueue
{
    SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] init];
    [requestQueue resume];
    
    // Empty queues can never be running
    XCTAssertFalse(requestQueue.running);
}

- (void)testDeallocation
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGRequestQueue *requestQueue;
    @autoreleasepool {
        requestQueue = [[SRGRequestQueue alloc] init];
    }
    XCTAssertNil(requestQueue);
#pragma clang diagnostic pop
}

- (void)testDeallocationWithRequests
{
    [self expectationForElapsedTimeInterval:3. withHandler:nil];
 
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGRequestQueue *requestQueue;
    @autoreleasepool {
        requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
            if (finished) {
                XCTFail(@"No finished state change expected since the queue is deallocated early");
            }
        }];
        SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
            XCTFail(@"The request must be cancelled when the parent queue is deallocated");
        }];
        [requestQueue addRequest:request resume:YES];
    }
    [self waitForExpectationsWithTimeout:5. handler:nil];
#pragma clang diagnostic pop
}

- (void)testParallelRequests
{
    __block BOOL request1Finished = NO;
    __block BOOL request2Finished = NO;
    __block BOOL requestQueueFinished = NO;
    
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];
    
    XCTestExpectation *request1CompletionExpectation = [self expectationWithDescription:@"Request 1 completed"];
    XCTestExpectation *request2CompletionExpectation = [self expectationWithDescription:@"Request 2 completed"];
    
    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertNil(error);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            XCTAssertTrue(request1Finished);
            XCTAssertTrue(request2Finished);
            
            requestQueueFinished = YES;
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *request1 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertFalse(requestQueueFinished);
        [requestQueue reportError:error];
        
        request1Finished = YES;
        [request1CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request1 resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertFalse(requestQueueFinished);
        [requestQueue reportError:error];
        
        request2Finished = YES;
        [request2CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request2 resume:YES];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request1.running);
    XCTAssertFalse(request2.running);
    XCTAssertFalse(requestQueue.running);
}

- (void)testCascadingRequests
{
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];
    
    XCTestExpectation *requestsFinishedExpectation = [self expectationWithDescription:@"Requests finished"];
    
    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertNil(error);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *videosRequest = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        
        SRGMedia *firstMedia = medias.firstObject;
        XCTAssertNotNil(firstMedia);
        
        SRGRequest *mediaCompositionRequest = [self.dataProvider tvMediaCompositionWithUid:firstMedia.uid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
            [requestQueue reportError:error];
            
            [requestsFinishedExpectation fulfill];
        }];
        [requestQueue addRequest:mediaCompositionRequest resume:YES];
        XCTAssertTrue(mediaCompositionRequest.running);
    }];
    [requestQueue addRequest:videosRequest resume:YES];
    XCTAssertTrue(videosRequest.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(videosRequest.running);
    XCTAssertFalse(requestQueue.running);
}

- (void)testError
{
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];
    
    XCTestExpectation *requestCompletionExpectation = [self expectationWithDescription:@"Request completed"];
    
    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            XCTAssertNil(error);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            XCTAssertEqualObjects(error.domain, SRGDataProviderErrorDomain);
            XCTAssertEqual(error.code, SRGDataProviderErrorHTTP);
            
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *request = [self.dataProvider tvMediaCompositionWithUid:@"invalid_id" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [requestCompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request resume:YES];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testErrors
{
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];
    
    XCTestExpectation *request1CompletionExpectation = [self expectationWithDescription:@"Request 1 completed"];
    XCTestExpectation *request2CompletionExpectation = [self expectationWithDescription:@"Request 2 completed"];
    
    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            XCTAssertNil(error);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            XCTAssertEqualObjects(error.domain, SRGDataProviderErrorDomain);
            XCTAssertEqual(error.code, SRGDataProviderErrorMultiple);
            XCTAssertEqual([error.userInfo[SRGDataProviderErrorsKey] count], 2);
            
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *request1 = [self.dataProvider tvMediaCompositionWithUid:@"invalid_id1" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [request1CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request1 resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider tvMediaCompositionWithUid:@"invalid_id2" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [request2CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request2 resume:YES];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request1.running);
    XCTAssertFalse(request2.running);
    XCTAssertFalse(requestQueue.running);
}

- (void)testGlobalResume
{
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];
    
    XCTestExpectation *request1CompletionExpectation = [self expectationWithDescription:@"Request 1 completed"];
    XCTestExpectation *request2CompletionExpectation = [self expectationWithDescription:@"Request 2 completed"];
    
    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertNil(error);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *request1 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [request1CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request1 resume:NO];
    
    // The queue is not running yet
    XCTAssertFalse(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [request2CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request2 resume:NO];
    
    // The queue is still not running yet
    XCTAssertFalse(requestQueue.running);
    
    // Now run the queue
    [requestQueue resume];
    XCTAssertTrue(requestQueue.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request1.running);
    XCTAssertFalse(request2.running);
    XCTAssertFalse(requestQueue.running);
}

- (void)testGlobalCancel
{
    XCTestExpectation *queueStartedExpectation = [self expectationWithDescription:@"Queue started"];
    XCTestExpectation *queueFinishedExpectation = [self expectationWithDescription:@"Queue finished"];
    
    __block SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertNil(error);
        
        if (! finished) {
            XCTAssertTrue(requestQueue.running);
            [queueStartedExpectation fulfill];
        }
        else {
            XCTAssertFalse(requestQueue.running);
            [queueFinishedExpectation fulfill];
        }
    }];
    
    SRGRequest *request1 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTFail(@"Completion block must not be called when the request has been cancelled");
    }];
    [requestQueue addRequest:request1 resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider tvSoonExpiringMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTFail(@"Completion block must not be called when the request has been cancelled");
    }];
    [requestQueue addRequest:request2 resume:YES];
    
    // Immediately cancel the queue
    [requestQueue cancel];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    XCTAssertFalse(request1.running);
    XCTAssertFalse(request2.running);
    XCTAssertFalse(requestQueue.running);
}

- (void)testKVOStateChanges
{
    SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] init];
    
    // Add a request to the queue and run it. Wait until the queue does not run anymore
    [self keyValueObservingExpectationForObject:requestQueue keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    SRGRequest *request1 = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    [requestQueue addRequest:request1 resume:YES];
    XCTAssertTrue(requestQueue.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    // Add a second request. The queue must run again
    [self keyValueObservingExpectationForObject:requestQueue keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        XCTAssertTrue([NSThread isMainThread]);
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    SRGRequest *request2 = [self.dataProvider tvSoonExpiringMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    [requestQueue addRequest:request2 resume:YES];
    XCTAssertTrue(requestQueue.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testReuse
{
    SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] init];
    SRGRequest *request = [self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Not interested in individual request status
    }];
    [requestQueue addRequest:request resume:NO];
    
    // Wait until the queue is not running anymore
    [self keyValueObservingExpectationForObject:requestQueue keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    [requestQueue resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    // Restart it
    [self keyValueObservingExpectationForObject:request keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    [requestQueue resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

@end
