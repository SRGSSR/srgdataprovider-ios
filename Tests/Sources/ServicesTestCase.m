//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <XCTest/XCTest.h>

#import <SRGDataProvider/SRGDataProvider.h>

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
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
