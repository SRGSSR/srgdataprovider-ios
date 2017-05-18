//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

static NSString * const kVideoRTSURN = @"urn:rts:video:8478255";
static NSString * const kVideoRTSOtherURN = @"urn:rts:video:8478153";

static NSString * const kAudioRTSURN = @"urn:rts:audio:8438184";

static NSString * const kMediaSRFURN = @"urn:srf:video:e7cfd700-e14e-43b4-9710-3527fc2098bc";

static NSString * const kInvalidMediaURN = @"urn:rts:video:999999999999999";

@interface CommonServicesTestCase : DataProviderBaseTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation CommonServicesTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    // Data provider business unit is irrelevant, such services can be accessed from any data provider.
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierSWI];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testMedia
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:[SRGMediaURN mediaURNWithString:kVideoRTSURN] completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:[SRGMediaURN mediaURNWithString:kInvalidMediaURN] completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNil(media);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMedias
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[[SRGMediaURN mediaURNWithString:kVideoRTSURN], [SRGMediaURN mediaURNWithString:kVideoRTSOtherURN]] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[[SRGMediaURN mediaURNWithString:kVideoRTSURN], [SRGMediaURN mediaURNWithString:kAudioRTSURN]] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[[SRGMediaURN mediaURNWithString:kVideoRTSURN], [SRGMediaURN mediaURNWithString:kMediaSRFURN]] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[[SRGMediaURN mediaURNWithString:kVideoRTSURN], [SRGMediaURN mediaURNWithString:kVideoRTSOtherURN], [SRGMediaURN mediaURNWithString:kInvalidMediaURN]] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[[SRGMediaURN mediaURNWithString:kInvalidMediaURN]] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediaComposition
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:[SRGMediaURN mediaURNWithString:kVideoRTSURN] completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:[SRGMediaURN mediaURNWithString:kInvalidMediaURN] completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNil(mediaComposition);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
