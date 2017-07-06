//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface ShowURNTestCase : DataProviderBaseTestCase

@end

@implementation ShowURNTestCase

#pragma mark Tests

- (void)testCreation
{
    NSString *URNString = @"urn:srf:show:online:400741a5-0289-474b-807c-01679a6986c0";
    
    SRGShowURN *showURN = [[SRGShowURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(showURN.uid, @"400741a5-0289-474b-807c-01679a6986c0");
    XCTAssertEqualObjects(@(showURN.transmission), @(SRGTransmissionOnline));
    XCTAssertEqualObjects(@(showURN.vendor), @(SRGVendorSRF));
    XCTAssertEqualObjects(showURN.URNString, URNString);
}

- (void)testCaseInsensitive
{
    SRGShowURN *showURN1 = [[SRGShowURN alloc] initWithURNString:@"URN:srf:show:online:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNotNil(showURN1);
    
    SRGShowURN *showURN2 = [[SRGShowURN alloc] initWithURNString:@"urn:SRF:show:online:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNotNil(showURN2);
    
    SRGShowURN *showURN3 = [[SRGShowURN alloc] initWithURNString:@"Urn:srf:SHOW:ONLINE:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNotNil(showURN3);
}

- (void)testCaseSensitive
{
    SRGShowURN *showURN = [[SRGShowURN alloc] initWithURNString:@"urn:srf:show:online:TeStUrN"];
    XCTAssertNotNil(showURN);
    XCTAssertEqualObjects(showURN.uid, @"TeStUrN");
}

- (void)testIncorrectURNs
{
    SRGShowURN *showURN1 = [[SRGShowURN alloc] initWithURNString:@"fakeURN:srf:show:online:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNil(showURN1);
    
    SRGShowURN *showURN2 = [[SRGShowURN alloc] initWithURNString:@"urn:srf:online:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNil(showURN2);
    
    SRGShowURN *showURN3 = [[SRGShowURN alloc] initWithURNString:@"urn:srf:show:online:"];
    XCTAssertNil(showURN3);
    
    SRGShowURN *showURN4 = [[SRGShowURN alloc] initWithURNString:@"urn:srf:dummy:online:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNil(showURN4);
    
    SRGShowURN *showURN5 = [[SRGShowURN alloc] initWithURNString:@"urn:srf:show:dummy:400741a5-0289-474b-807c-01679a6986c0"];
    XCTAssertNil(showURN5);
}

- (void)testEquality
{
    SRGShowURN *showURN1 = [[SRGShowURN alloc] initWithURNString:@"urn:swi:show:online:1"];
    SRGShowURN *showURN2 = [[SRGShowURN alloc] initWithURNString:@"urn:swi:show:online:1"];
    SRGShowURN *showURN3 = [[SRGShowURN alloc] initWithURNString:@"urn:srf:show:online:1"];
    SRGShowURN *showURN4 = [[SRGShowURN alloc] initWithURNString:@"urn:swi:show:online:100"];
    SRGShowURN *showURN5 = [[SRGShowURN alloc] initWithURNString:@"urn:swi:show:radio:1"];
    
    XCTAssertTrue([showURN1 isEqual:showURN2]);
    XCTAssertFalse([showURN1 isEqual:showURN3]);
    XCTAssertFalse([showURN1 isEqual:showURN4]);
    XCTAssertFalse([showURN1 isEqual:showURN5]);
}

@end
