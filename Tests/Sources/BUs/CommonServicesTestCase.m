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

static NSString * const kTVShowSRFURN = @"urn:srf:show:tv:6fd27ab0-d10f-450f-aaa9-836f1cac97bd";
static NSString * const kTVShowSRFOtherURN = @"urn:srf:show:tv:c38cc259-b5cd-4ac1-b901-e3fddd901a3d";

static NSString * const kRadioShowSRFURN = @"urn:srf:show:radio:da260da8-2efd-49b0-9e7b-977f5f254f0d";

static NSString * const kShowRTSURN = @"urn:rts:show:tv:6454706";

static NSString * const kTopicRTSURN = @"urn:rts:topic:tv:1081";
static NSString * const kTopicSRFURN = @"urn:srf:topic:tv:a709c610-b275-4c0c-a496-cba304c36712";
static NSString * const kTopicRTRURN = @"urn:rtr:topic:tv:20e7478f-1ea1-49c3-81c2-5f157d6ff092";

static NSString * const kInvalidMediaURN = @"urn:rts:video:999999999999999";
static NSString * const kInvalidShow1URN = @"urn:srf:show:tv:999999999999999";
static NSString * const kInvalidShow2URN = @"urn:rts:show:tv:999999999999999";
static NSString * const kInvalidShow3URN = @"urn:show:tv:999999999999999";

@interface CommonServicesTestCase : DataProviderBaseTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation CommonServicesTestCase

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

- (void)testMediaWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoRTSURN completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kInvalidMediaURN completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNil(media);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediasWithURNs
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kVideoRTSOtherURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kAudioRTSURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kMediaSRFURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kVideoRTSOtherURN, kInvalidMediaURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kInvalidMediaURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestMediasForTopicWithURN
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestMediasForTopicWithURN:kTopicRTSURN completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMostPopularMediasForTopicWithURN
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mostPopularMediasForTopicWithURN:kTopicRTSURN completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediaCompositionWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoRTSURN standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kInvalidMediaURN standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNil(mediaComposition);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kTVShowSRFURN completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kInvalidShow1URN completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNil(show);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowsWithURNs
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kRadioShowSRFURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kShowRTSURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kInvalidShow1URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kInvalidShow2URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kInvalidShow3URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation6 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation7 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kInvalidShow1URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation7 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowsWithTopicURNs
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForTopicURNs:@[kTopicSRFURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForTopicURNs:@[kTopicRTRURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForTopicURNs:@[kTopicSRFURN, kTopicRTRURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsForTopicURNs:@[kTopicSRFURN, kTopicRTSURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEpisodesForShowWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestEpisodesForShowWithURN:kTVShowSRFURN maximumPublicationMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider latestEpisodesForShowWithURN:kTVShowSRFURN maximumPublicationMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Cannot test -latestMediasForModuleWithURN:completionBlock: yet due to missing reliable data

@end
