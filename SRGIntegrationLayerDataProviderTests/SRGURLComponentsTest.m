//
//  SRGURLComponentsTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SRGILList.h"
#import "SRGILModel.h"
#import "SRGILDataProvider.h"
#import "SRGILURLComponents.h"

@interface SRGURLComponentsTest : XCTestCase
@property(nonatomic, strong) SRGILDataProvider *dataProvider;
@end

@implementation SRGURLComponentsTest

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

- (void)testWrongIndex
{
    NSError *error = nil;
    SRGILURLComponents *components = [self.dataProvider URLComponentsForFetchListIndex:-1
                                                                         withIdentifier:nil
                                                                                  error:&error];
    
    XCTAssertNil(components);
    XCTAssertNotNil(error);
}

- (void)testIndexVideoLiveStreams
{
    NSError *error = nil;
    SRGILURLComponents *components = [self.dataProvider URLComponentsForFetchListIndex:SRGILFetchListVideoLiveStreams
                                                                         withIdentifier:nil
                                                                                  error:&error];
    
    XCTAssertNotNil(components);
    XCTAssertNotNil(components.path);
    XCTAssertNil(components.queryItems);
    XCTAssertNil(error);
}

- (void)testIndexVideoSearch
{
    NSError *error = nil;
    SRGILURLComponents *components = [self.dataProvider URLComponentsForFetchListIndex:SRGILFetchListVideoSearch
                                                                         withIdentifier:nil
                                                                                  error:&error];
    
    XCTAssertNotNil(components);
    XCTAssertNotNil(components.path);
    XCTAssertNotNil(components.queryItems);
    XCTAssertNil(error);

    XCTAssertTrue([components.string containsString:@"pageSize="]);

    [components updateQueryItemsWithSearchString:@"dump_test_search_string"];
    XCTAssertTrue([components.string containsString:@"q=dump_test_search_string"]);
}

@end
