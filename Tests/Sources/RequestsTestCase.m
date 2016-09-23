//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <XCTest/XCTest.h>

#import <SRGDataProvider/SRGDataProvider.h>

@interface RequestsTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

// Other things to test:
//  - data provider creation, global data provider
//  - request creation and management. Reusing requests and trying to start requests several times
//  - request queue
//  - model objects

@implementation RequestsTestCase

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

#pragma mark Test

- (void)testEditorialVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Editorial video request succeeded"];
    
    [[self.dataProvider editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:5. handler:nil];
}

- (void)testCancelledRequest
{
    // Cancel block must not be called
    XCTFail(@"TODO");
}

@end
