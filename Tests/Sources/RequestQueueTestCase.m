//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

@interface RequestQueueTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RequestQueueTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    NSURL *serviceURL = [NSURL URLWithString:@"http://il-test.srgssr.ch"];
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSWI];
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
    
    SRGRequest *request = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *request1 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertFalse(requestQueueFinished);
        [requestQueue reportError:error];
        
        request1Finished = YES;
        [request1CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request1 resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *videosRequest = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        
        SRGMedia *firstMedia = medias.firstObject;
        XCTAssertNotNil(firstMedia);
        
        SRGRequest *mediaCompositionRequest = [self.dataProvider mediaCompositionForVideoWithUid:firstMedia.uid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
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
    
    SRGRequest *request = [self.dataProvider mediaCompositionForVideoWithUid:@"invalid_id" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
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
    
    SRGRequest *request1 = [self.dataProvider mediaCompositionForVideoWithUid:@"invalid_id1" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [request1CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request1 resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider mediaCompositionForVideoWithUid:@"invalid_id2" completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
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
    
    SRGRequest *request1 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        [requestQueue reportError:error];
        [request1CompletionExpectation fulfill];
    }];
    [requestQueue addRequest:request1 resume:NO];
    
    // The queue is not running yet
    XCTAssertFalse(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    SRGRequest *request1 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTFail(@"Completion block must not be called when the request has been cancelled");
    }];
    [requestQueue addRequest:request1 resume:YES];
    
    // The queue is immediately running
    XCTAssertTrue(requestQueue.running);
    
    SRGRequest *request2 = [self.dataProvider soonExpiringVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    SRGRequest *request1 = [self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    [requestQueue addRequest:request1 resume:YES];
    XCTAssertTrue(requestQueue.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
    
    // Add a second request. The queue must run again
    [self keyValueObservingExpectationForObject:requestQueue keyPath:@"running" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        return [change[NSKeyValueChangeNewKey] isEqual:@NO];
    }];
    
    SRGRequest *request2 = [self.dataProvider soonExpiringVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        // Nothing
    }];
    [requestQueue addRequest:request2 resume:YES];
    XCTAssertTrue(requestQueue.running);
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

@end
