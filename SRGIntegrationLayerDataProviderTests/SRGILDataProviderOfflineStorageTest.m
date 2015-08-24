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

#import "SRGILURN.h"
#import "SRGILDataProvider.h"
#import "SRGILDataProvider+MediaPlayer.h"
#import "SRGILDataProvider+OfflineStorage.h"

@interface SRGOfflineStorageCenter (Private)
- (void)__resetCenter__;
@end

@interface SRGILDataProvider (Private)
@property(nonatomic, strong) SRGOfflineStorageCenter *storageCenter;
@end

@interface SRGILDataProviderOfflineStorageTest : XCTestCase
@property(nonatomic, strong) NSString *validMediaURNString;
@property(nonatomic, strong) NSString *validShowIdentifier;
@property(nonatomic, strong) SRGILDataProvider *dataProvider;
@end

@implementation SRGILDataProviderOfflineStorageTest

- (void)setUp
{
    [super setUp];
    self.validMediaURNString = @"urn:rts:video:6853450"; // One Infrarouge emission
    self.validShowIdentifier = @"404386";
    self.dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
}

- (void)tearDown
{
    [super tearDown];
    [self.dataProvider.storageCenter __resetCenter__];
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
    XCTAssertFalse([dataProvider isMediaFlaggedAsFavorite:self.validMediaURNString]);
    XCTAssertFalse([dataProvider isShowFlaggedAsFavorite:self.validShowIdentifier]);
}

- (void)testDataProviderOfflineStorageWithKnownMediaIdentifier
{
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid content URL for the identifier %@",
                                       self.validMediaURNString]];
    
    [self.dataProvider mediaPlayerController:nil
                        contentURLForIdentifier:self.validMediaURNString
                            completionHandler:^(NSURL *contentURL, NSError *error) {
                              [expectation fulfill];
                            }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    [self.dataProvider flagAsFavorite:YES mediaWithURNString:self.validMediaURNString audioChannelID:nil];
    XCTAssertTrue([self.dataProvider isMediaFlaggedAsFavorite:self.validMediaURNString]);
    XCTAssertTrue([[self.dataProvider flaggedAsFavoriteMediaMetadatas] count] == 1);
    
    [self.dataProvider flagAsFavorite:NO mediaWithURNString:self.validMediaURNString audioChannelID:nil];
    XCTAssertFalse([self.dataProvider isMediaFlaggedAsFavorite:self.validMediaURNString]);
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

- (void)testDataProviderOfflineStorageMigrationFromIdentifierToURNString
{
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];
    
    // Use private method to insert old-style metadata into DB.
    dataProvider.storageCenter = [SRGOfflineStorageCenter favoritesOffineStorageCenter];
    
    id mediaMetadaMock = OCMProtocolMock(@protocol(SRGMediaMetadataContainer));
    OCMStub([mediaMetadaMock identifier]).andReturn([SRGILURN identifierForURNString:self.validMediaURNString]);
    
    [dataProvider.storageCenter flagAsFavorite:YES
                                 mediaMetadata:mediaMetadaMock];
    
    XCTAssertTrue([self.dataProvider isMediaFlaggedAsFavorite:[SRGILURN identifierForURNString:self.validMediaURNString]]);
    XCTAssertTrue([self.dataProvider isMediaFlaggedAsFavorite:self.validMediaURNString]);
    
    // When flagging again, the metadata with the identifier must disappear, even when flagging with the same value.
    [dataProvider flagAsFavorite:YES mediaWithURNString:self.validMediaURNString audioChannelID:nil];
    XCTAssertTrue([self.dataProvider isMediaFlaggedAsFavorite:self.validMediaURNString]);
    XCTAssertFalse([self.dataProvider isMediaFlaggedAsFavorite:[SRGILURN identifierForURNString:self.validMediaURNString]]);
}

@end
