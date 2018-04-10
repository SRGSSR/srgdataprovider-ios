//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

static NSString * const kAudioSearchQuery = @"tennis";
static NSString * const kAudioURN = @"urn:rsi:audio:8800213";

static NSString * const kRadioChannelUid = @"rete-uno";
static NSString * const kRadioLivestreamUid = @"none_yet";
static NSString * const kRadioShowSearchQuery = @"modem";

static NSString * const kVideoSearchQuery = @"roger";
static NSString * const kVideoURN = @"urn:rsi:video:8812327";

static NSString * const kTVChannelUid = @"la1";
static NSString * const kTVShowSearchQuery = @"telegiornale";

@interface RSIServicesTestCase : DataProviderBaseTestCase

@property (nonatomic) SRGDataProvider *dataProvider;

@end

@implementation RSIServicesTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
}

- (void)tearDown
{
    self.dataProvider = nil;
}

#pragma mark Tests

- (void)testTVChannels
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvChannelsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvChannelForVendor:SRGVendorRSI withUid:kTVChannelUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLivestreams
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLivestreamsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVScheduledLivestreams
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvScheduledLivestreamsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVEditorialMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvEditorialMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvLatestMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVMostPopularMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvMostPopularMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVSoonExpiringMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvSoonExpiringMediasForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVTrendingMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvTrendingMediasForVendor:SRGVendorRSI withLimit:nil completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVLatestEpisodes
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvLatestEpisodesForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider tvEpisodesForVendor:SRGVendorRSI date:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider tvEpisodesForVendor:SRGVendorRSI date:dateComponents.date withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvTopicsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error) {
        XCTAssertNotNil(topics);
        XCTAssertNil(error);
        
        SRGTopic *topic = topics.firstObject;
        XCTAssertNotNil(topic);
        XCTAssertNotEqual(topic.subtopics.count, 0);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTVShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider tvShowsForVendor:SRGVendorRSI matchingQuery:kTVShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    [[self.dataProvider radioChannelsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGChannel *> * _Nullable channels, NSError * _Nullable error) {
        XCTAssertNotNil(channels);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioChannel
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioChannelForVendor:SRGVendorRSI withUid:kRadioChannelUid livestreamUid:nil completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(channel);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    // No livestreams for RSI yet
    [[self.dataProvider radioChannelForVendor:SRGVendorRSI withUid:kRadioChannelUid livestreamUid:kRadioLivestreamUid completionBlock:^(SRGChannel * _Nullable channel, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreamsForContentProviders
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI contentProviders:SRGContentProvidersDefault withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI contentProviders:SRGContentProvidersAll withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request 3 succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI contentProviders:SRGContentProvidersSwissSatelliteRadio withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLivestreamsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLivestreamsForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioLatestMediasForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestMediasForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioMostPopularMedias
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioMostPopularMediasForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Not available for RSI
- (void)testRadioLatestEpisodesForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestEpisodesForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioEpisodesForDate
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request 1 succeeded"];
    
    [[self.dataProvider radioEpisodesForVendor:SRGVendorRSI date:nil channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request 2 succeeded"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2016;
    dateComponents.month = 5;
    dateComponents.day = 12;
    
    [[self.dataProvider radioEpisodesForVendor:SRGVendorRSI date:dateComponents.date channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Not supported for RSI
- (void)testRadioLatestVideosForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioLatestVideosForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(shows);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioShowsMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioShowsForVendor:SRGVendorRSI matchingQuery:kRadioShowSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultShow *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    [[self.dataProvider radioSongsForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(NSArray<SRGSong *> * _Nullable songs, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(songs);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRadioCurrentSongForChannel
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider radioCurrentSongForVendor:SRGVendorRSI channelUid:kRadioChannelUid withCompletionBlock:^(SRGSong * _Nullable song, NSError * _Nullable error) {
        // The song might be nil if nothing is being played on air 
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testOnlineShows
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider onlineShowsForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNil(shows);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLiveCenterVideos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideosMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider videosForVendor:SRGVendorRSI matchingQuery:kVideoSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotNil(searchResults);
        XCTAssertNotNil(total);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudiosMatchingQuery
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider audiosForVendor:SRGVendorRSI matchingQuery:kAudioSearchQuery withCompletionBlock:^(NSArray<SRGSearchResultMedia *> * _Nullable searchResults, NSNumber * _Nullable total, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
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
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation1 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGLike mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation2 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeFacebookShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation3 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeTwitterShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation4 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeGooglePlusShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation5 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeWhatsAppShare mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation6 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation7 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotEqual(medias.count, 0);
        XCTAssertNil(error);
        
        [[self.dataProvider mediaCompositionWithURN:medias.firstObject.URN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
            XCTAssertNotNil(mediaComposition);
            
            [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView mediaComposition:mediaComposition withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
                XCTAssertNotNil(socialCountOverview);
                XCTAssertNil(error);
                [expectation7 fulfill];
            }] resume];
        }] resume];
        
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testIncreaseSocialCountWithSubdivision
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation1 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGLike subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation2 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeFacebookShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation3 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeTwitterShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation4 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeGooglePlusShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation5 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:kVideoURN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        
        [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeWhatsAppShare subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
            XCTAssertNotNil(socialCountOverview);
            XCTAssertNil(error);
            [expectation6 fulfill];
        }] resume];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation7 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider liveCenterVideosForVendor:SRGVendorRSI withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        XCTAssertNotEqual(medias.count, 0);
        XCTAssertNil(error);
        
        [[self.dataProvider mediaCompositionWithURN:medias.firstObject.URN chaptersOnly:YES completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
            XCTAssertNotNil(mediaComposition);
            
            [[self.dataProvider increaseSocialCountForType:SRGSocialCountTypeSRGView subdivision:mediaComposition.mainChapter withCompletionBlock:^(SRGSocialCountOverview * _Nullable socialCountOverview, NSError * _Nullable error) {
                XCTAssertNotNil(socialCountOverview);
                XCTAssertNil(error);
                [expectation7 fulfill];
            }] resume];
        }] resume];
        
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testModules
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider modulesForVendor:SRGVendorRSI type:SRGModuleTypeEvent withCompletionBlock:^(NSArray<SRGModule *> * _Nullable modules, NSError * _Nullable error) {
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
    [[self.dataProvider mediaCompositionWithURN:@"urn:rsi:video:8950717" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"8950717");
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // VOD segment
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:@"urn:rsi:video:9014449" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"8950717");
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // VOD clip
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:@"urn:rsi:video:9016660" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"9016660");
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // Video livestream
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:@"urn:rsi:video:livestream_La1" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"livestream_La1");
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // AOD clip
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:@"urn:rsi:audio:8923771" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"8923771");
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    // Audio livestream
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionWithURN:@"urn:rsi:audio:livestream_ReteUno" chaptersOnly:NO completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
        XCTAssertEqualObjects(mediaComposition.fullLengthMedia.uid, @"livestream_ReteUno");
        [expectation6 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoImageScaleWidth
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionWidth withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // Resizing not well supported at the moment (image size not guaranteed). Only check image availability.
        XCTAssertNotNil(image);

        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testVideoImageScaleHeight
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kVideoURN completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionHeight withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // Not supported
        XCTAssertNil(image);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioImageScaleWidth
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kAudioURN completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionWidth withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // Resizing not well supported at the moment (image size not guaranteed). Only check image availability.
        XCTAssertNotNil(image);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testAudioImageScaleHeight
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kAudioURN completionBlock:^(SRGMedia * _Nullable media, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        NSURL *imageURL = [media imageURLForDimension:SRGImageDimensionHeight withValue:300.f type:SRGImageTypeDefault];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        // Not supported
        XCTAssertNil(image);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
