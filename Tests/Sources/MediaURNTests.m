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
    NSString *URNString = @"urn:swi:video:41981254";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"41981254");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSWI));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
}

- (void)testSRGMediaURNForSRFCreation
{
    NSString *URNString = @"urn:srf:ais:video:4a70cbd6-4575-43ce-a7ca-766f7e2fb974";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"4a70cbd6-4575-43ce-a7ca-766f7e2fb974");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSRF));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
}

- (void)testSRGFake1MediaURNCreation
{
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:@"fakeURN:swi:video:41981254"];
    XCTAssertNil(mediaURN);
}

- (void)testSRGFake2MediaURNCreation
{
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:@"swi:video:41981254"];
    XCTAssertNil(mediaURN);
}

@end
