//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderNetwork;
@import XCTest;

@interface ContentServicesTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation ContentServicesTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    // Data provider business unit is irrelevant, such services can be accessed from any data provider.
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testContentPage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider contentPageForVendor:SRGVendorRTS uid:@"40d9e6dd-00ac-4b84-98b8-3fa66cfe2df3" published:YES atDate:nil withCompletionBlock:^(SRGContentPage * _Nullable contentPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(contentPage);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testContentPageForMediaType
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider contentPageForVendor:SRGVendorRTS mediaType:SRGMediaTypeVideo published:YES atDate:nil withCompletionBlock:^(SRGContentPage * _Nullable contentPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(contentPage);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testContentPageForTopic
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider contentPageForVendor:SRGVendorSRF topicWithURN:@"urn:srf:topic:tv:a709c610-b275-4c0c-a496-cba304c36712" published:YES atDate:nil withCompletionBlock:^(SRGContentPage * _Nullable contentPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(contentPage);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testContentSection
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider contentSectionForVendor:SRGVendorRTS uid:@"3ef86d33-bf99-472e-8e74-a88794b803ef" published:YES withCompletionBlock:^(SRGContentSection * _Nullable contentSection, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(contentSection);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediasForContentSection
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasForVendor:SRGVendorRTS contentSectionUid:@"3ef86d33-bf99-472e-8e74-a88794b803ef" userId:nil published:YES atDate:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowsForContentSection
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForVendor:SRGVendorRTS contentSectionUid:@"810c9049-e004-4a01-a442-b5cd66f65f33" userId:nil published:YES atDate:nil withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowAndMediasForContentSection
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showAndMediasForVendor:SRGVendorRTS contentSectionUid:@"8c135f15-3762-4777-af5a-c719c18a3068" userId:nil published:YES atDate:nil withCompletionBlock:^(SRGShowAndMedias * _Nullable showAndMedias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(showAndMedias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
