//
//  SRGILSearchRequestTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Frédéric VERGEZ on 29/07/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"
#import "SRGILSearchResult.h"

@interface SRGILSearchRequestTest : XCTestCase
@property(nonatomic) SRGILSearchResult *searchResult;
@end

@implementation SRGILSearchRequestTest

- (void)setUp {
    [super setUp];
    self.searchResult = [[SRGILSearchResult alloc]
                         initWithDictionary:[self loadJSONFile:@"searchRequest_01" withClassName:@"SearchResult"]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitData {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}


@end
