//
//  SRGFetchListsTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"

#import "SRGILList.h"
#import "SRGILModel.h"
#import "SRGILDataProvider.h"
#import "SRGILURLComponents.h"

static NSString *const SRFRadioVirusChannelID = @"66815fe2-9008-4853-80a5-f9caaffdf3a9";

@interface SRGFetchListsTest : XCTestCase
@property(nonatomic, strong) SRGILDataProvider *dataProvider;
@end

@implementation SRGFetchListsTest

- (void)setUp
{
    [super setUp];
    self.dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
}

- (void)tearDown
{
    self.dataProvider = nil;
    [super tearDown];
}

- (void)testFetchListTopics
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURLComponents *components = [SRGILURLComponents componentsForFetchListIndex:SRGILFetchListVideoTopics
                                                                         withIdentifier:nil
                                                                                  error:nil];
    
    [self.dataProvider fetchObjectsListWithURLComponents:components
                                               organised:SRGILModelDataOrganisationTypeFlat
                                              progressBlock:nil
                                            completionBlock:^(SRGILList * _Nullable items, Class  _Nullable __unsafe_unretained itemClass, NSError * _Nullable error) {
                                                [expectation fulfill];
                                                XCTAssertNil(error);
                                                XCTAssertTrue(itemClass == SRGILTopic.class);
                                                XCTAssertTrue(items.count > 0);
                                            }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testFetchListSonglogPlaying
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURLComponents *components = [SRGILURLComponents componentsForFetchListIndex:SRGILFetchListSonglogPlaying
                                                                         withIdentifier:SRFRadioVirusChannelID
                                                                                  error:nil];
    
    [self.dataProvider fetchObjectsListWithURLComponents:components
                                               organised:SRGILModelDataOrganisationTypeFlat
                                              progressBlock:nil
                                            completionBlock:^(SRGILList * _Nullable items, Class  _Nullable __unsafe_unretained itemClass, NSError * _Nullable error) {
                                                [expectation fulfill];
                                                XCTAssertNil(error);
                                                XCTAssertTrue(itemClass == SRGILSonglog.class);
                                                XCTAssertTrue(items.count > 0);
                                            }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testFetchListSonglogLatest
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURLComponents *components = [SRGILURLComponents componentsForFetchListIndex:SRGILFetchListSonglogLatest
                                                                         withIdentifier:SRFRadioVirusChannelID
                                                                                  error:nil];
    
    [self.dataProvider fetchObjectsListWithURLComponents:components
                                               organised:SRGILModelDataOrganisationTypeFlat
                                              progressBlock:nil
                                            completionBlock:^(SRGILList * _Nullable items, Class  _Nullable __unsafe_unretained itemClass, NSError * _Nullable error) {
                                                [expectation fulfill];
                                                XCTAssertNil(error);
                                                XCTAssertTrue(itemClass == SRGILSonglog.class);
                                                XCTAssertTrue(items.count > 0);
                                            }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}


@end
