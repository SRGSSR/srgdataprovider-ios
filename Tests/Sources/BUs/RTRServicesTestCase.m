//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

static NSString * const kAudioChannelUid = @"12fb886e-b7aa-4e55-beb2-45dbc619f3c4";
static NSString * const kAudioLivestreamUid = @"";
static NSString * const kAudioSearchQuery = @"roger";
static NSString * const kAudioShowSearchQuery = @"actualitad";
static NSString * const kAudioShowUid = @"e0c6add1-55a2-4ae1-af09-143fd7f29a31";
static NSString * const kAudioUid = @"4e0291b5-b718-480c-840e-80c746dff1a8";
static NSString * const kAudioOtherUid = @"716f5280-5110-4f99-afe7-aeeaf6cf3b8b";

static NSString * const kVideoChannelUid = @"none_yet";
static NSString * const kVideoSearchQuery = @"tennis";
static NSString * const kVideoShowUid = @"c482ada1-acc0-0001-8415-847c2ad01c59";
static NSString * const kVideoShowSearchQuery = @"controvers";
static NSString * const kVideoUid = @"63cc0629-615c-4e97-93cc-f770d2ce4e79";
static NSString * const kVideoOtherUid = @"6c326059-3acc-467e-bca3-73bd7d3057fe";

static NSString * const kTopicUid = @"none_yet";

@interface RTRServicesTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RTRServicesTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTR];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testTVChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvChannelsWithCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvChannelWithUid:kVideoChannelUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLivestreams
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVEditorialMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvEditorialMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVSoonExpiringMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    // Not supported for RTR
    [[self.dataProvider tvSoonExpiringMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVTrendingMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvTrendingMediasWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestEpisodesForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLatestEpisodesWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvEpisodesForDate:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider tvEpisodesForDate:dateComponents.date withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMedia
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvMediaWithUid:kVideoUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvMediasWithUids:@[kVideoUid, kVideoOtherUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvTopicsWithCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        XCTAssertNotNil(topics);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestMediasForTopic
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvLatestMediasForTopicWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];

    // No topics exist for RTR
    [[self.dataProvider tvLatestMediasForTopicWithUid:kTopicUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMostPopularMediasForTopic
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvMostPopularMediasForTopicWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    // No topics exist for RTR
    [[self.dataProvider tvMostPopularMediasForTopicWithUid:kTopicUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsWithCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowWithUid:kVideoShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvLatestEpisodesForShowWithUid:kVideoShowUid oldestMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider tvLatestEpisodesForShowWithUid:kVideoShowUid oldestMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMediaComposition
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvMediaCompositionWithUid:kVideoUid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMediasMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvMediasMatchingQuery:kVideoSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsMatchingQuery:kVideoShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioChannelsWithCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioChannel
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioChannelWithUid:kAudioChannelUid livestreamUid:nil completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    // No livestreams for RTR yet
    [[self.dataProvider radioChannelWithUid:kAudioChannelUid livestreamUid:kAudioLivestreamUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreams
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioLivestreamsForChannelWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider radioLivestreamsForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestMediasForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestMediasForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMostPopularMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMostPopularMediasForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestEpisodesForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestEpisodesForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioEpisodesForDate:nil withChannelUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider radioEpisodesForDate:dateComponents.date withChannelUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMedia
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMediaWithUid:kAudioUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMediasWithUids:@[kAudioUid, kAudioOtherUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowWithUid:kAudioShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioLatestEpisodesForShowWithUid:kAudioShowUid oldestMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider radioLatestEpisodesForShowWithUid:kAudioShowUid oldestMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMediaComposition
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMediaCompositionWithUid:kAudioUid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMediasMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMediasMatchingQuery:kAudioSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsMatchingQuery:kAudioShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testModules
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider modulesWithType:SRGModuleTypeEvent completionBlock:^(NSArray<SRGModule *> * _Nullable modules, NSError * _Nullable error) {
        XCTAssertNotNil(modules);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Cannot test -latestMediasForModuleWithType:uid:sectionUid:completionBlock: yet due to missing reliable data

@end
