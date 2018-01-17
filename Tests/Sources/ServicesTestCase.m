//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface ServicesTestCase : DataProviderBaseTestCase

@end

@implementation ServicesTestCase

#pragma mark Test

- (void)testTokenizeAkamaiURL
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request succeeded"];
    
    NSURL *URL = [NSURL URLWithString:@"https://rtsvodww-vh.akamaihd.net/i/tj/2017/tj_20171011_full_f_1040162-,301k,101k,701k,1201k,2001k,.mp4.csmil/master.m3u8"];
    SRGRequest *request = [SRGDataProvider tokenizeURL:URL withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
        XCTAssertNotNil(URL);
        XCTAssertNil(error);
        
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
        NSArray<NSString *> *parameters = [URLComponents valueForKeyPath:@"queryItems.@distinctUnionOfObjects.name"];
        XCTAssertTrue([parameters containsObject:@"hdnts"]);
        
        [expectation fulfill];
    }];
    XCTAssertNotNil(request);
    [request resume];
    
    [self waitForExpectationsWithTimeout:30. handler:nil];
}

- (void)testTokenizeNonAkamaiURL
{
    NSURL *URL = [NSURL URLWithString:@"http://stream-i.rts.ch/i/bidbi/2007/bidbi_01082007-,450,k.mp4.csmil/master.m3u8"];
    SRGRequest *request = [SRGDataProvider tokenizeURL:URL withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
        // Nothing
    }];
    XCTAssertNil(request);
}

@end
