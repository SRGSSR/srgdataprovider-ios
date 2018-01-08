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
    XCTAssertFalse(mediaURN.liveCenterEvent);
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
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:@"urn:rsi:video:livestream_La1"];
    XCTAssertNotNil(mediaURN);
    XCTAssertEqualObjects(mediaURN.uid, @"livestream_La1");
}

- (void)testSwissTXTURN
{
    NSString *URNString = @"urn:swisstxt:video:srf:5288f730-b776-4ff7-8b52-8028ec0d238a";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"5288f730-b776-4ff7-8b52-8028ec0d238a");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorSRF));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
    XCTAssertTrue(mediaURN.liveCenterEvent);
}

- (void)testSwissSatelliteRadioURN
{
    NSString *URNString = @"urn:rts:ssatr:audio:rsp";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"rsp");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeAudio));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
    XCTAssertFalse(mediaURN.liveCenterEvent);
}

- (void)testScheduledLivestreamURN
{
    NSString *URNString = @"urn:rts:scheduled_livestream:video:ea4af24f-311d-45d0-a697-be56c8b3f59e";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"ea4af24f-311d-45d0-a697-be56c8b3f59e");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
    XCTAssertFalse(mediaURN.liveCenterEvent);
}

- (void)testLivestreamURN
{
    NSString *URNString = @"urn:rts:livestream:video:ea4af24f-311d-45d0-a697-be56c8b3f59e";
    
    SRGMediaURN *mediaURN = [[SRGMediaURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(mediaURN.uid, @"ea4af24f-311d-45d0-a697-be56c8b3f59e");
    XCTAssertEqualObjects(@(mediaURN.mediaType), @(SRGMediaTypeVideo));
    XCTAssertEqualObjects(@(mediaURN.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(mediaURN.URNString, URNString);
    XCTAssertFalse(mediaURN.liveCenterEvent);
}

- (void)testIncorrectURNs
{
    SRGMediaURN *mediaURN1 = [[SRGMediaURN alloc] initWithURNString:@"fakeURN:swi:video:41981254"];
    XCTAssertNil(mediaURN1);
    
    SRGMediaURN *mediaURN2 = [[SRGMediaURN alloc] initWithURNString:@"swi:video:41981254"];
    XCTAssertNil(mediaURN2);
    
    SRGMediaURN *mediaURN3 = [[SRGMediaURN alloc] initWithURNString:@"swi:video:"];
    XCTAssertNil(mediaURN3);
    
    SRGMediaURN *mediaURN4 = [[SRGMediaURN alloc] initWithURNString:@"urn:swisstxt:video:srf:"];
    XCTAssertNil(mediaURN4);
    
    SRGMediaURN *mediaURN5 = [[SRGMediaURN alloc] initWithURNString:@"urn:swisstxt:"];
    XCTAssertNil(mediaURN5);
    
    SRGMediaURN *mediaURN6 = [[SRGMediaURN alloc] initWithURNString:@"urn:ssatr:audio:rts:rsp"];
    XCTAssertNil(mediaURN6);
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
