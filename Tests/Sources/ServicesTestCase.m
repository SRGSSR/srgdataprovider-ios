//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

@interface ServicesTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation ServicesTestCase

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
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// TODO: Add tests for other services

@end
