//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

@interface MediaURNTests : XCTestCase

@end

@implementation MediaURNTests

- (void)testSRGMediaURNForSWICreation
{
    NSString *URN = @"urn:swi:video:41981254";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURN:URN];
    XCTAssertEqualObjects(mediaURN.uid, @"41981254");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSWI));
    XCTAssertEqualObjects(mediaURN.URN, URN);
}

- (void)testSRGMediaURNForSRFCreation
{
    NSString *URN = @"urn:srf:ais:video:4a70cbd6-4575-43ce-a7ca-766f7e2fb974";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURN:URN];
    XCTAssertEqualObjects(mediaURN.uid, @"4a70cbd6-4575-43ce-a7ca-766f7e2fb974");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSRF));
    XCTAssertEqualObjects(mediaURN.URN, URN);
}

- (void)testSRGFake1MediaURNCreation
{
    NSString *URN = @"fakeURN:swi:video:41981254";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURN:URN];
    XCTAssertNil(mediaURN);
}

- (void)testSRGFake2MediaURNCreation
{
    NSString *URN = @"swi:video:41981254";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURN:URN];
    XCTAssertNil(mediaURN);
}

@end
