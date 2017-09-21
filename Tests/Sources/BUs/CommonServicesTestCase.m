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

static NSString * const kShowURN = @"urn:srf:show:tv:6fd27ab0-d10f-450f-aaa9-836f1cac97bd";

static NSString * const kInvalidMediaURN = @"urn:rts:video:999999999999999";
static NSString * const kInvalidShowURN = @"urn:rts:show:tv:999999999999999";

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

- (void)testMediaWithURN
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

- (void)testMediasWithURNs
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

- (void)testMediaCompositionWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:[SRGMediaURN mediaURNWithString:kVideoRTSURN] chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:[SRGMediaURN mediaURNWithString:kInvalidMediaURN] chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNil(mediaComposition);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:[SRGShowURN showURNWithString:kShowURN] completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:[SRGShowURN showURNWithString:kInvalidShowURN] completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNil(show);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEpisodesForShowWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestEpisodesForShowWithURN:[SRGShowURN showURNWithString:kShowURN] oldestMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider latestEpisodesForShowWithURN:[SRGShowURN showURNWithString:kShowURN] oldestMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
