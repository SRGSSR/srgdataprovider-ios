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
#import "SRGILURLComponents.h"

@interface SRGURLComponentsTest : XCTestCase

@end

@implementation SRGURLComponentsTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testWrongIndex
{
    NSError *error = nil;
    SRGILURLComponents *components = [SRGILURLComponents URLComponentsForFetchListIndex:-1
                                                                         withIdentifier:nil
                                                                                  error:&error];
    
    XCTAssertNil(components);
    XCTAssertNotNil(error);
}

- (void)testIndexVideoLiveStreams
{
    NSError *error = nil;
    SRGILURLComponents *components = [SRGILURLComponents URLComponentsForFetchListIndex:SRGILFetchListVideoLiveStreams
                                                                         withIdentifier:nil
                                                                                  error:&error];
    
    XCTAssertNotNil(components);
    XCTAssertNotNil(components.path);
    XCTAssertNil(components.queryItems);
    XCTAssertNil(error);
}

@end
