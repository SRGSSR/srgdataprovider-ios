//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface MediaURNTestCase : DataProviderBaseTestCase

@end

@implementation MediaURNTestCase

#pragma mark Tests

- (void)testCreation
{
    NSString *URNString = @"urn:swi:video:41981254";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"41981254");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSWI));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
}

- (void)testCaseInsensitive
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"URN:swi:video:41981254"];
    XCTAssertNotNil(mediaURN1);
    
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"urn:SWI:video:41981254"];
    XCTAssertNotNil(mediaURN2);
    
    SRGMediaURN *mediaURN3 = [[SRGMediaURN alloc] initWithURNString:@"Urn:swi:VIDEO:41981254"];
    XCTAssertNotNil(mediaURN3);
}

- (void)testCaseSensitive
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"urn:rsi:video:livestream_La1"];
    XCTAssertNotNil(mediaURN1);
    XCTAssertNotEqualObjects(mediaURN1.uid, @"livestream_la1");
    XCTAssertEqualObjects(mediaURN1.uid, @"livestream_La1");
    
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"urn:rtr:video:269e6a58-a9cb-11e3-ac2b-fbf4986f02ad"];
    XCTAssertNotNil(mediaURN2);
    XCTAssertNotEqualObjects(mediaURN2.uid, @"269E6A58-A9CB-11E3-AC2B-FBF4986F02AD");
    XCTAssertNotEqualObjects(mediaURN2.uid, @"269e6a58-a9cb-11e3-ac2b-fbf4986f02AD");
    XCTAssertEqualObjects(mediaURN2.uid, @"269e6a58-a9cb-11e3-ac2b-fbf4986f02ad");
}

- (void)testIncorrectURNs
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"fakeURN:swi:video:41981254"];
    XCTAssertNil(mediaURN1);
    
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"swi:video:41981254"];
    XCTAssertNil(mediaURN2);
}

- (void)testEquality
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:video:41981254"];
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:video:41981254"];
    SRGMediaURN *mediaURN3 = [[SRGMediaURN alloc] initWithURNString:@"urn:srf:video:41981254"];
    SRGMediaURN *mediaURN4 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:video:99999999"];
    SRGMediaURN *mediaURN5 = [[SRGMediaURN alloc] initWithURNString:@"urn:swi:audio:41981254"];
    
    XCTAssertTrue([mediaURN1 isEqual:mediaURN2]);
    XCTAssertFalse([mediaURN1 isEqual:mediaURN3]);
    XCTAssertFalse([mediaURN1 isEqual:mediaURN4]);
    XCTAssertFalse([mediaURN1 isEqual:mediaURN5]);
}

@end
