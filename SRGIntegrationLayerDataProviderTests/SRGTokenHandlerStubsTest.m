//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <XCTest/XCTest.h>
#import "SRGILTokenHandler.h"

static NSString *const kTokenBaseUrl = @"http://www.srf.ch/player/token?acl=/";

@interface SRGILTokenHandlerTest : XCTestCase
@end

@implementation SRGILTokenHandlerTest


- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSingletonInstance
{
    SRGILTokenHandler *handler1 = [SRGILTokenHandler sharedHandler];
    XCTAssertNotNil(handler1, @"Should not be nil");
    
    SRGILTokenHandler *handler2 = [SRGILTokenHandler sharedHandler];
    XCTAssertEqualObjects(handler1, handler2, @"Different object returned for a singleton");
}

- (void)testRequestTokenForURL
{
    static NSString *const urlString = @"http://rts.ch/something/to/play/video/test.m4u";
    NSURL * url = [NSURL URLWithString:urlString];
    
    SRGILTokenRequestCompletionBlock block = ^(NSURL *tokenizedURL, NSError *error) {
        XCTAssertNotNil(tokenizedURL, @"Nil return value");
        XCTAssertTrue([tokenizedURL.absoluteString hasPrefix:urlString], @"Bad prefix");
    };
    
    [[SRGILTokenHandler sharedHandler] requestTokenForURL:url
                                appendLogicalSegmentation:@""
                                          completionBlock:block];
}

@end
