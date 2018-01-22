//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

static NSString * const kAudioSearchQuery = @"roger";
static NSString * const kAudioUid = @"4e0291b5-b718-480c-840e-80c746dff1a8";
static NSString * const kAudioOtherUid = @"716f5280-5110-4f99-afe7-aeeaf6cf3b8b";

static NSString * const kRadioChannelUid = @"12fb886e-b7aa-4e55-beb2-45dbc619f3c4";
static NSString * const kRadioLivestreamUid = @"";
static NSString * const kRadioShowSearchQuery = @"actualitad";
static NSString * const kRadioShowUid = @"e0c6add1-55a2-4ae1-af09-143fd7f29a31";
static NSString * const kRadioShowOtherUid = @"e0c6add1-55a2-4ae1-af09-143fd7f29a31";

static NSString * const kVideoSearchQuery = @"tennis";
static NSString * const kVideoUid = @"63cc0629-615c-4e97-93cc-f770d2ce4e79";
static NSString * const kVideoOtherUid = @"6c326059-3acc-467e-bca3-73bd7d3057fe";

static NSString * const kTVChannelUid = @"none_yet";
static NSString * const kTVShowUid = @"c70b9b6d-5cc0-0001-68ab-1cf01c502e60";
static NSString * const kTVShowOtherUid = @"c6027339-38d0-0001-2720-fad31ff21478";
static NSString * const kTVShowSearchQuery = @"controvers";

static NSString * const kOnlineShowUid = @"c6d3dfe6-62d0-0001-7d23-bc2e11a04a10";
static NSString * const kOnlineShowOtherUid = @"c70b9a24-6640-0001-56ca-5f4011091e9a";

static NSString * const kTopicUid = @"none_yet";

static NSString * const kInvalidMediaId = @"999999999999999";

@interface RTRServicesTestCase : DataProviderBaseTestCase

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
    
    [[self.dataProvider tvChannelWithUid:kTVChannelUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
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

- (void)testTVScheduledLivestreams
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvScheduledLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    [[self.dataProvider tvTrendingMediasWithLimit:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestEpisodes
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

- (void)testTVShowsWithUids
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsWithUids:@[kTVShowUid, kTVShowOtherUid] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowWithUid:kTVShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvLatestEpisodesForShowWithUid:kTVShowUid maximumPublicationMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider tvLatestEpisodesForShowWithUid:kTVShowUid maximumPublicationMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsMatchingQuery:kTVShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNotNil(total);
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
    
    [[self.dataProvider radioChannelWithUid:kRadioChannelUid livestreamUid:nil completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    // No livestreams for RTR yet
    [[self.dataProvider radioChannelWithUid:kRadioChannelUid livestreamUid:kRadioLivestreamUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreamsForContentProviders
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioLivestreamsForContentProviders:SRGContentProvidersDefault withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider radioLivestreamsForContentProviders:SRGContentProvidersAll withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 succeeded"];
    
    [[self.dataProvider radioLivestreamsForContentProviders:SRGContentProvidersSwissSatelliteRadio withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreamsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLivestreamsForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestMediasForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestMediasForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMostPopularMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMostPopularMediasForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestEpisodesForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestEpisodesForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioEpisodesForDate:nil withChannelUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider radioEpisodesForDate:dateComponents.date withChannelUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Not supported for RTR
- (void)testRadioLatestVideosForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestVideosForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsWithUids
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsWithUids:@[kRadioShowUid, kRadioShowOtherUid] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowWithUid:kRadioShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioLatestEpisodesForShowWithUid:kRadioShowUid maximumPublicationMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider radioLatestEpisodesForShowWithUid:kRadioShowUid maximumPublicationMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsMatchingQuery:kRadioShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNotNil(total);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioSongsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioSongsForChannelWithUid:kRadioChannelUid completionBlock:^(NSArray<SRGSong *> * _Nullable songs, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(songs);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioCurrentSongForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioCurrentSongForChannelWithUid:kRadioChannelUid completionBlock:^(SRGSong * _Nullable song, NSError * _Nullable error) {
        // The song might be nil if nothing is being played on air
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testOnlineShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider onlineShowsWithCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testOnlineShowsWithUids
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider onlineShowsWithUids:@[kOnlineShowUid, kOnlineShowOtherUid] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testOnlineShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider onlineShowWithUid:kOnlineShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testOnlineLatestEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider onlineLatestEpisodesForShowWithUid:kOnlineShowUid maximumPublicationMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider onlineLatestEpisodesForShowWithUid:kOnlineShowUid maximumPublicationMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLiveCenterVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideo
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoWithUid:kVideoUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoWithUid:kInvalidMediaId completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNil(media);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideos
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosWithUids:@[kVideoUid, kVideoOtherUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosWithUids:@[kInvalidMediaId] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    // The service supports partial retrieval when some uid is invalid
    [[self.dataProvider videosWithUids:@[kVideoUid, kVideoOtherUid, kInvalidMediaId] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];

}

- (void)testVideoMediaComposition
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideosMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosMatchingQuery:kVideoSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNotNil(total);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudio
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioWithUid:kAudioUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioWithUid:kInvalidMediaId completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNil(media);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudios
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audiosWithUids:@[kAudioUid, kAudioOtherUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audiosWithUids:@[kInvalidMediaId] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNil(medias);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    // The service supports partial retrieval when some uid is invalid
    [[self.dataProvider audiosWithUids:@[kAudioUid, kAudioOtherUid, kInvalidMediaId] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioMediaComposition
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioMediaCompositionWithUid:kAudioUid chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudiosMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audiosMatchingQuery:kAudioSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNotNil(total);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testIncreaseSocialCountWithMediaComposition
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation1 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGLike mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation2 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeFacebookShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation3 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeTwitterShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation4 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeGooglePlusShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation5 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeWhatsAppShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation6 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testIncreaseSocialCountWithSubdivision
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation1 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGLike subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation2 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeFacebookShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation3 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeTwitterShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation4 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeGooglePlusShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation5 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:kVideoUid chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeWhatsAppShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation6 fulfill];
        }] resume];
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

- (void)testFullLength
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    // Full-length VOD
    [[self.dataProvider videoMediaCompositionWithUid:@"c797f923-1c13-412f-8764-099fa6aa9f36" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"c797f923-1c13-412f-8764-099fa6aa9f36");
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // VOD segment
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:@"b4948988-e5d6-4c7b-bf41-0fbce93ac3f4" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"c797f923-1c13-412f-8764-099fa6aa9f36");
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // VOD clip
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:@"0ae543a9-d0b4-402e-aea6-a50a8169fb2f" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"0ae543a9-d0b4-402e-aea6-a50a8169fb2f");
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // Video livestream
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoMediaCompositionWithUid:@"269e6a58-a9cb-11e3-ac2b-fbf4986f02ad" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"269e6a58-a9cb-11e3-ac2b-fbf4986f02ad");
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // AOD (are their own full-length for RTR)
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioMediaCompositionWithUid:@"1fc78a87-1ccb-4b8b-b103-980334d6ad94" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"1fc78a87-1ccb-4b8b-b103-980334d6ad94");
        [expectation6 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // Audio livestream
    XCTestExpectation *expectation7 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioMediaCompositionWithUid:@"a029e818-77a5-4c2e-ad70-d573bb865e31" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"a029e818-77a5-4c2e-ad70-d573bb865e31");
        [expectation7 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoImageScaleWidth
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoWithUid:kVideoUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionWidth withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.width, 300.);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoImageScaleHeight
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoWithUid:kVideoUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionHeight withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.height, 300.);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioImageScaleWidth
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioWithUid:kAudioUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionWidth withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        XCTAssertEqual(image.size.width, 300.);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioImageScaleHeight
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioWithUid:kAudioUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionHeight withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // Resizing not well supported at the moment (image size not guaranteed). Only check image availability.
        XCTAssertNotNil(image);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
