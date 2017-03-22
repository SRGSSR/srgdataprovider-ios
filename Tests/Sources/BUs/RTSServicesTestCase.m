//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

static NSString * const kAudioChannelUid = @"a9e7621504c6959e35c3ecbe7f6bed0446cdf8da";
static NSString * const kAudioLivestreamUid = @"none_yet";
static NSString * const kAudioSearchQuery = @"roger";
static NSString * const kAudioShowSearchQuery = @"supersonic";
static NSString * const kAudioShowUid = @"5168249";
static NSString * const kAudioUid = @"8438184";
static NSString * const kAudioOtherUid = @"8441579";

static NSString * const kVideoChannelUid = @"143932a79bb5a123a646b68b1d1188d7ae493e5b";
static NSString * const kVideoSearchQuery = @"tennis";
static NSString * const kVideoShowUid = @"6454706";
static NSString * const kVideoShowSearchQuery = @"entendeur";
static NSString * const kVideoUid = @"8478255";
static NSString * const kVideoOtherUid = @"8478153";

static NSString * const kTopicUid = @"1081";

static NSString * const kModuleUid = @"c01f03b2-5546-4c94-bb78-2a2b1dbd206c";

@interface RTSServicesTestCase : XCTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RTSServicesTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testVideoChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoChannelsWithCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoChannelWithUid:kVideoChannelUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoLivestreams
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoLivestreamsWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEditorialVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Not supported for RTS
- (void)testSoonExpiringVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider soonExpiringVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestVideoEpisodes
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider latestVideoEpisodesForChannelWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    // Not supported for RTS
    [[self.dataProvider latestVideoEpisodesForChannelWithUid:kVideoChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTrendingVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider videoEpisodesForDate:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider videoEpisodesForDate:dateComponents.date withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideo
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoWithUid:kVideoUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosWithUids:@[kVideoUid, kVideoOtherUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoTopicsWithCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        XCTAssertNotNil(topics);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestVideosForTopic
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider latestVideosForTopicWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider latestVideosForTopicWithUid:kTopicUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMostPopularVideosForTopic
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider mostPopularVideosForTopicWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider mostPopularVideosForTopicWithUid:kTopicUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoShowsWithCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videoShowWithUid:kVideoShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestVideoEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider latestVideoEpisodesForShowWithUid:kVideoShowUid oldestMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider latestVideoEpisodesForShowWithUid:kVideoShowUid oldestMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoMediaComposition
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForVideoWithUid:kVideoUid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testSearchVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider searchVideosMatchingQuery:kVideoSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testSearchVideoShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider searchVideoShowsMatchingQuery:kVideoShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioChannelsWithCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioChannel
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider audioChannelWithUid:kAudioChannelUid livestreamUid:nil completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    // No livestreams for RSI yet
    [[self.dataProvider audioChannelWithUid:kAudioChannelUid livestreamUid:kAudioLivestreamUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioLivestreams
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider audioLivestreamsForChannelWithUid:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider audioLivestreamsForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestAudiosForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestAudiosForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestAudioEpisodesForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestAudioEpisodesForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMostPopularAudios
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mostPopularAudiosForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider audioEpisodesForDate:nil withChannelUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider audioEpisodesForDate:dateComponents.date withChannelUid:kAudioChannelUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudio
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioWithUid:kAudioUid completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudios
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audiosWithUids:@[kAudioUid, kAudioOtherUid] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioShowsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioShowsForChannelWithUid:kAudioChannelUid completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioShow
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audioShowWithUid:kAudioShowUid completionBlock:^(SRGShow * _Nullable show, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestAudioEpisodesForShow
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider latestAudioEpisodesForShowWithUid:kAudioShowUid oldestMonth:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    
    [[self.dataProvider latestAudioEpisodesForShowWithUid:kAudioShowUid oldestMonth:dateComponents.date completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioMediaComposition
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForAudioWithUid:kAudioUid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testSearchAudios
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider searchAudiosMatchingQuery:kAudioSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testSearchAudioShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider searchAudioShowsMatchingQuery:kAudioShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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

- (void)testLatestMediasForModule
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];

    // Event always available in test
    SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerTestServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    [[dataProvider latestMediasForModuleWithType:SRGModuleTypeEvent uid:kModuleUid completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
