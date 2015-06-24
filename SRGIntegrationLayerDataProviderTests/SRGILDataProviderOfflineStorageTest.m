//
//  SRGILDataProviderMediaPlayerTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 15/06/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <SRGAnalytics/SRGAnalytics.h>

#import "SRGILDataProvider.h"
#import "SRGILDataProvider+MediaPlayer.h"
#import "SRGILDataProvider+OfflineStorage.h"

@interface SRGILDataProviderOfflineStorageTest : XCTestCase
@property(nonatomic, strong) NSString *validMediaIdentifier;
@property(nonatomic, strong) NSString *validShowIdentifier;
@property(nonatomic, strong) SRGILDataProvider *dataProvider;
@end

@implementation SRGILDataProviderOfflineStorageTest

- (void)setUp
{
    [super setUp];
    self.validMediaIdentifier = @"6853450"; // One Infrarouge emission
    self.validShowIdentifier = @"404386";
    self.dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
}

- (void)tearDown
{
    [super tearDown];
    self.dataProvider = nil;
}

- (void)testDataProviderOfflineStorageWithNilIdentifier
{
    XCTAssertFalse([self.dataProvider isMediaFlaggedAsFavorite:nil]);
    XCTAssertFalse([self.dataProvider isShowFlaggedAsFavorite:nil]);
    XCTAssertEqual([self.dataProvider flaggedAsFavoriteMediaMetadatas], @[]);
    XCTAssertEqual([self.dataProvider flaggedAsFavoriteShowMetadatas], @[]);
}

- (void)testDataProviderOfflineStorageWithUnknownIdentifier
{
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    XCTAssertFalse([dataProvider isMediaFlaggedAsFavorite:self.validMediaIdentifier]);
    XCTAssertFalse([dataProvider isShowFlaggedAsFavorite:self.validShowIdentifier]);
}

- (void)testDataProviderOfflineStorageWithKnownMediaIdentifier
{
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       self.validMediaIdentifier]];
    
    [self.dataProvider mediaPlayerController:nil
                        contentURLForIdentifier:self.validMediaIdentifier
                            completionHandler:^(NSURL *contentURL, NSError *error) {
                              [expectation fulfill];
                            }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    [self.dataProvider flagAsFavorite:YES mediaWithIdentifier:self.validMediaIdentifier audioChannelID:nil];
    XCTAssertTrue([self.dataProvider isMediaFlaggedAsFavorite:self.validMediaIdentifier]);
    XCTAssertTrue([[self.dataProvider flaggedAsFavoriteMediaMetadatas] count] == 1);
    
    [self.dataProvider flagAsFavorite:NO mediaWithIdentifier:self.validMediaIdentifier audioChannelID:nil];
    XCTAssertFalse([self.dataProvider isMediaFlaggedAsFavorite:self.validMediaIdentifier]);
    XCTAssertTrue([[self.dataProvider flaggedAsFavoriteMediaMetadatas] count] == 0);
}

- (void)testDataProviderOfflineStorageWithKnownShowIdentifier
{
    [self.dataProvider fetchListOfIndex:SRGILFetchListVideoShowsAZ
                       withPathArgument:nil
                              organised:SRGILModelDataOrganisationTypeAlphabetical
                             onProgress:nil
                           onCompletion:^(SRGILList *items, __unsafe_unretained Class itemClass, NSError *error) {
                               [self.dataProvider flagAsFavorite:YES showWithIdentifier:self.validShowIdentifier audioChannelID:nil];
                               XCTAssertTrue([self.dataProvider isShowFlaggedAsFavorite:self.validShowIdentifier]);
                               XCTAssertTrue([[self.dataProvider flaggedAsFavoriteShowMetadatas] count] == 1);
                               
                               [self.dataProvider flagAsFavorite:NO showWithIdentifier:self.validShowIdentifier audioChannelID:nil];
                               XCTAssertFalse([self.dataProvider isShowFlaggedAsFavorite:self.validShowIdentifier]);
                               XCTAssertTrue([[self.dataProvider flaggedAsFavoriteShowMetadatas] count] == 0);
                           }];
    
}

@end
