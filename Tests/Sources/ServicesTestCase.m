//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface ServicesTestCase : DataProviderBaseTestCase

@end

@implementation ServicesTestCase

#pragma mark Test

- (void)testTokenizeURL
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSURL *URL = [NSURL URLWithString:@"http://stream-i.rts.ch/i/bidbi/2007/bidbi_01082007-,450,k.mp4.csmil/master.m3u8"];
    [[SRGDataProvider tokenizeURL:URL withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
        XCTAssertNotNil(URL);
        XCTAssertNil(error);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

@end
