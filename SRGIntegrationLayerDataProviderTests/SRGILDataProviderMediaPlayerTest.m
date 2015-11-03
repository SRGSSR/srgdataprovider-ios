//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <SRGAnalytics/SRGAnalytics.h>

#import "SRGILDataProvider.h"
#import "SRGILDataProvider+MediaPlayer.h"

@interface SRGILDataProviderMediaPlayerTest : XCTestCase

@end

@implementation SRGILDataProviderMediaPlayerTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDataProviderConformances
{
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    XCTAssertTrue([dataProvider conformsToProtocol:@protocol(RTSMediaPlayerControllerDataSource)]);
    XCTAssertTrue([dataProvider conformsToProtocol:@protocol(RTSMediaSegmentsDataSource)]);
    XCTAssertTrue([dataProvider conformsToProtocol:@protocol(RTSAnalyticsMediaPlayerDataSource)]);
}

#pragma mark - Analytics

- (void)testDataProviderMediaPlayerControllerDataSourceWithValidRTSVideoIdentifier
{
    // http://www.rts.ch/play/tv/infrarouge/video/fifa-un-hôte-trop-encombrant-?id=6853450
    NSString *identifier = @"6853450";
    NSString *urnString = [@"urn:rts:video:" stringByAppendingString:identifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:urnString
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNotNil(contentURL, @"Content URL must be present.");
                          XCTAssertNil(error, @"Error must be nil.");
                          
                          XCTAssertNotNil([dataProvider streamSenseClipMetadataForIdentifier:urnString withSegment:nil]);
                          XCTAssertNotNil([dataProvider streamSensePlaylistMetadataForIdentifier:urnString]);
                          XCTAssertNotNil([dataProvider comScoreReadyToPlayLabelsForIdentifier:urnString]);
                          
                          NSDictionary *comscoreLabels = [dataProvider comScoreReadyToPlayLabelsForIdentifier:urnString];
                          XCTAssertTrue([comscoreLabels[@"name"] hasPrefix:@"Player.TV."], @"Wrong name label.");
                          XCTAssertTrue([comscoreLabels[@"category"] hasPrefix:@"TV."], @"Wrong name label.");
                          
                          if (!error && contentURL) {
                              NSLog(@"The contentURL is: %@", contentURL);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testDataProviderMediaPlayerControllerDataSourceWithValidSRFAudioIdentifier
{
    // SRF 1, Radio, Narichten, July 2015.
    NSString *identifier = @"bf993758-1416-4ce2-acac-26499403b773";
    NSString *urnString = [@"urn:srf:ais:audio:" stringByAppendingString:identifier]; // If "ais:" is missing, it doesn't work.
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:urnString
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNotNil(contentURL, @"Content URL must be present.");
                          XCTAssertNil(error, @"Error must be nil.");
                          
                          XCTAssertNotNil([dataProvider streamSenseClipMetadataForIdentifier:urnString withSegment:nil]);
                          XCTAssertNotNil([dataProvider streamSensePlaylistMetadataForIdentifier:urnString]);
                          XCTAssertNotNil([dataProvider comScoreReadyToPlayLabelsForIdentifier:urnString]);
                          
                          NSDictionary *comscoreLabels = [dataProvider comScoreReadyToPlayLabelsForIdentifier:urnString];
                          XCTAssertTrue([comscoreLabels[@"name"] hasPrefix:@"Player.Radio."], @"Wrong name label.");
                          XCTAssertTrue([comscoreLabels[@"category"] hasPrefix:@"Radio."], @"Wrong name label.");
                          
                          if (!error && contentURL) {
                              NSLog(@"The contentURL is: %@", contentURL);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:300.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testDataProviderMediaPlayerControllerDataSourceWithInvalidIdentifier
{
    // Invalid identifier
    NSString *identifier = @"685345028262-9320282";
    NSString *urnString = [@"urn:rts:video:" stringByAppendingString:identifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:urnString
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNil(contentURL, @"Content URL must be nil.");
                          XCTAssertNotNil(error, @"Error must be present.");
                          XCTAssertNil([dataProvider streamSenseClipMetadataForIdentifier:urnString withSegment:nil]);
                          XCTAssertNil([dataProvider streamSensePlaylistMetadataForIdentifier:urnString]);
                          XCTAssertNil([dataProvider comScoreReadyToPlayLabelsForIdentifier:urnString]);
                          
                          if (error) {
                              NSLog(@"completion error: %@", error);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testDataProviderMediaSegmentsDataSourceWithValidIdentifier
{
    // 19h30
    NSString *identifier = @"6414099";
    NSString *urnString = [@"urn:rts:video:" stringByAppendingString:identifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    [dataProvider segmentsController:nil
               segmentsForIdentifier:urnString
               withCompletionHandler:^(NSArray *segments, NSError *error) {
                   XCTAssertNil(error, @"Error must be nil");
                   
                   XCTAssertNotNil(segments, @"Missing segments");
                   XCTAssertTrue(segments.count > 0, @"Missing segments");
                   
                   XCTAssertNotNil([dataProvider streamSenseClipMetadataForIdentifier:urnString withSegment:nil]);
                   XCTAssertNotNil([dataProvider streamSensePlaylistMetadataForIdentifier:urnString]);
                   
                   for (id<RTSMediaSegment>segment in segments) {
                       XCTAssertNotNil([dataProvider streamSenseClipMetadataForIdentifier:urnString withSegment:segment]);
                   }
                   
                   if (segments && !error) {
                       [expectation fulfill];
                   }
               }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testDataProviderAnalyticsMediaPlayerDataSourceWithValidIdentifier
{
    // http://www.rts.ch/play/tv/infrarouge/video/fifa-un-hôte-trop-encombrant-?id=6853450
    NSString *identifier = @"6853450";
    NSString *urnString = [@"urn:rts:video:" stringByAppendingString:identifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:urnString
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNotNil(contentURL, @"Content URL must be present.");
                          XCTAssertNil(error, @"Error must be nil.");
                          
                          XCTAssertNotNil([dataProvider streamSensePlaylistMetadataForIdentifier:urnString]);
                          XCTAssertNotNil([dataProvider streamSenseClipMetadataForIdentifier:urnString withSegment:nil]);
                          
                          if (!error && contentURL) {
                              NSLog(@"The contentURL is: %@", contentURL);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

#pragma mark - Non-analytics

- (void)testDataProviderWithLogicalFullLengthAndPositiveMarkin
{
    // Added after: SPA-2151 blocker
    
    NSString *identifier = @"a516c083-9506-4096-8532-efbae378e6e7";
    NSString *urnString = [@"urn:srf:video:" stringByAppendingString:identifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       identifier]];
    
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
    [dataProvider mediaPlayerController:nil
                contentURLForIdentifier:urnString
                      completionHandler:^(NSURL *contentURL, NSError *error) {
                          XCTAssertNotNil(contentURL, @"Content URL must be present.");
                          XCTAssertNil(error, @"Error must be nil.");
                          
                          // Content URL must have start and end params in the case of logical
                          XCTAssertTrue([contentURL.query containsString:@"&start="], @"Content URL does not content 'start' param for logical segmentation");
                          XCTAssertTrue([contentURL.query containsString:@"&end="], @"Content URL does not content 'end' param for logical segmentation");
                          
                          // Test positive markout
                          NSArray *chunks = [contentURL.query componentsSeparatedByString:@"&"];
                          
                          [chunks enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                              NSArray *pair = [obj componentsSeparatedByString:@"="];
                              if ([pair count] == 2) {
                                  NSString *k = pair[0];
                                  NSString *v = pair[1];
                                  
                                  XCTAssertNotNil(k, @"Key must be present.");
                                  XCTAssertNotNil(v, @"Value must be present.");
                                  
                                  if ([k isEqualToString:@"start"]) {
                                      NSInteger startVal = [v integerValue];
                                      XCTAssertTrue(startVal > 0, @"The 'start' value should be equal to markin and positive" );
                                  }
                                  else
                                      if ([k isEqualToString:@"end"]) {
                                          NSInteger endVal = [v integerValue];
                                          XCTAssertTrue(endVal > 0, @"The 'start' value should be equal to markout and positive" );
                                      }
                              }
                          }];
                          
                          if (!error && contentURL) {
                              NSLog(@"The contentURL is: %@", contentURL);
                              [expectation fulfill];
                          }
                      }];
    
    [self waitForExpectationsWithTimeout:300.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


@end
