//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProviderNetwork;
@import XCTest;

static NSString * const kVideoRTSURN = @"urn:rts:video:8478255";
static NSString * const kVideoRTSOtherURN = @"urn:rts:video:8478153";

static NSString * const kAudioRTSURN = @"urn:rts:audio:8438184";

static NSString * const kMediaSRFURN = @"urn:srf:video:63bfc13e-25c0-4d0d-a132-f340ded4f7c2";

static NSString * const kTVShowSRFURN = @"urn:srf:show:tv:6fd27ab0-d10f-450f-aaa9-836f1cac97bd";
static NSString * const kTVShowSRFOtherURN = @"urn:srf:show:tv:c38cc259-b5cd-4ac1-b901-e3fddd901a3d";

static NSString * const kRadioShowSRFURN = @"urn:srf:show:radio:da260da8-2efd-49b0-9e7b-977f5f254f0d";

static NSString * const kShowRTSURN = @"urn:rts:show:tv:6454706";

static NSString * const kTopicURN = @"urn:rts:topic:tv:1081";
static NSString * const kInvalidTopicURN = @"urn:srf:topic:tv:1";

static NSString * const kInvalidMediaURN = @"urn:rts:video:999999999999999";
static NSString * const kInvalidShow1URN = @"urn:srf:show:tv:999999999999999";
static NSString * const kInvalidShow2URN = @"urn:rts:show:tv:999999999999999";
static NSString * const kInvalidShow3URN = @"urn:show:tv:999999999999999";

@interface CommonServicesTestCase : XCTestCase

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
    
    [[self.dataProvider mediaWithURN:kVideoRTSURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:kInvalidMediaURN completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(media);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediasWithURNs
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kVideoRTSOtherURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kAudioRTSURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kMediaSRFURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kAudioRTSURN, kInvalidMediaURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 2);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[kInvalidMediaURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 0);
        XCTAssertNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediasWithURNs:@[] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(medias.count, 0);
        XCTAssertNil(error);
        [expectation6 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediasWithURNsPagination
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Requests succeeded"];
    
    __block SRGFirstPageRequest *request1 = nil;
    request1 = [[self.dataProvider mediasWithURNs:@[kVideoRTSURN, kVideoRTSOtherURN, kMediaSRFURN] completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(error);
        
        if (page.number == 0) {
            XCTAssertEqual(medias.count, 2);
            XCTAssertEqualObjects(medias.firstObject.URN, kVideoRTSURN);
            XCTAssertNotNil(nextPage);
            
            SRGPageRequest *request2 = [request1 requestWithPage:nextPage];
            [request2 resume];
        }
        else if (page.number == 1) {
            XCTAssertEqual(medias.count, 1);
            XCTAssertEqualObjects(medias.firstObject.URN, kMediaSRFURN);
            XCTAssertNil(nextPage);
            
            [expectation fulfill];
            request1 = nil;
        }
        else {
            XCTFail(@"Only two pages are expected");
        }
    }] requestWithPageSize:2];
    [request1 resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testLatestMediasForTopicWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestMediasForTopicWithURN:kTopicURN completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestMediasForTopicWithURN:kInvalidTopicURN completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMostPopularMediasForTopicWithURN
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mostPopularMediasForTopicWithURN:kTopicURN completionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testRecommendedMedias
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider recommendedMediasForURN:kVideoRTSURN userId:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider recommendedMediasForURN:kMediaSRFURN userId:nil withCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(medias);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testMediaCompositionWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kVideoRTSURN standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(mediaComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaCompositionForURN:kInvalidMediaURN standalone:NO withCompletionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(mediaComposition);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kTVShowSRFURN completionBlock:^(SRGShow * _Nullable show, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(show);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showWithURN:kInvalidShow1URN completionBlock:^(SRGShow * _Nullable show, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNil(show);
        XCTAssertNotNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testShowsWithURNs
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kRadioShowSRFURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kShowRTSURN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 3);
        XCTAssertNil(error);
        [expectation3 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation4 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kInvalidShow1URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation4 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation5 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kInvalidShow2URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation5 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation6 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kTVShowSRFURN, kTVShowSRFOtherURN, kInvalidShow3URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 2);
        XCTAssertNil(error);
        [expectation6 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation7 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[kInvalidShow1URN] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 0);
        XCTAssertNil(error);
        [expectation7 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation8 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider showsWithURNs:@[] completionBlock:^(NSArray<SRGShow *> * _Nullable shows, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertEqual(shows.count, 0);
        XCTAssertNil(error);
        [expectation8 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testEpisodesForShowWithURN
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider latestEpisodesForShowWithURN:kTVShowSRFURN maximumPublicationDay:nil completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    SRGDay *day = [SRGDay day:31 month:5 year:2016];
    [[self.dataProvider latestEpisodesForShowWithURN:kTVShowSRFURN maximumPublicationDay:day completionBlock:^(SRGEpisodeComposition * _Nullable episodeComposition, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(episodeComposition);
        XCTAssertNil(error);
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

// Cannot test -latestMediasForModuleWithURN:completionBlock: yet due to missing reliable data

- (void)testMediaWithSubtitleInformationAndAudioTracks
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request succeeded"];
    
    [[self.dataProvider mediaWithURN:@"urn:srf:video:f8239f1d-c105-4f97-b6a6-1a0fe32951d4" completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        XCTAssertEqual(media.subtitleVariants.count, 1);
        XCTAssertEqual([media subtitleVariantsForSource:SRGVariantSourceHLS].count, 1);
        XCTAssertEqual([media subtitleVariantsForSource:SRGVariantSourceExternal].count, 0);
        XCTAssertEqual([media subtitleVariantsForSource:SRGVariantSourceDASH].count, 0);
        XCTAssertEqual(media.recommendedSubtitleVariantSource, SRGVariantSourceHLS);
        
        XCTAssertEqual(media.audioVariants.count, 0);
        
        SRGVariant *HLSSubtitleVariant = [media subtitleVariantsForSource:SRGVariantSourceHLS].firstObject;
        XCTAssertEqual(HLSSubtitleVariant.source, SRGVariantSourceHLS);
        XCTAssertEqual(HLSSubtitleVariant.type, SRGVariantTypeSDH);
        XCTAssertNotNil(HLSSubtitleVariant.locale);
        
        [expectation1 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Request succeeded"];
    
    self.dataProvider = [[SRGDataProvider alloc] initWithServiceURL:[NSURL URLWithString:@"https://play-mmf.herokuapp.com/integrationlayer"]];
    [[self.dataProvider mediaWithURN:@"urn:rts:video:_rts19h30_2" completionBlock:^(SRGMedia * _Nullable media, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        XCTAssertNotNil(media);
        XCTAssertNil(error);
        
        XCTAssertEqual(media.subtitleVariants.count, 2);
        XCTAssertEqual([media subtitleVariantsForSource:SRGVariantSourceHLS].count, 1);
        XCTAssertEqual([media subtitleVariantsForSource:SRGVariantSourceExternal].count, 1);
        XCTAssertEqual([media subtitleVariantsForSource:SRGVariantSourceDASH].count, 0);
        XCTAssertEqual(media.recommendedSubtitleVariantSource, SRGVariantSourceHLS);
        
        XCTAssertEqual(media.audioVariants.count, 1);
        XCTAssertEqual([media audioVariantsForSource:SRGVariantSourceHLS].count, 1);
        XCTAssertEqual(media.recommendedAudioVariantSource, SRGVariantSourceHLS);
        
        SRGVariant *HLSSubtitleVariant = [media subtitleVariantsForSource:SRGVariantSourceHLS].firstObject;
        XCTAssertEqual(HLSSubtitleVariant.source, SRGVariantSourceHLS);
        XCTAssertEqual(HLSSubtitleVariant.type, SRGVariantTypeSDH);
        XCTAssertNotNil(HLSSubtitleVariant.locale);
        
        SRGVariant *externalSubtitleVariant = [media subtitleVariantsForSource:SRGVariantSourceExternal].firstObject;
        XCTAssertEqual(externalSubtitleVariant.source, SRGVariantSourceExternal);
        XCTAssertEqual(externalSubtitleVariant.type, SRGVariantTypeSDH);
        XCTAssertNotNil(externalSubtitleVariant.locale);
        
        SRGVariant *audioVariant = media.audioVariants.firstObject;
        XCTAssertEqual(audioVariant.source, SRGVariantSourceHLS);
        XCTAssertEqual(audioVariant.type, SRGVariantTypeNone);
        XCTAssertNotNil(audioVariant.locale);
        
        [expectation2 fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:20. handler:nil];
}

@end
