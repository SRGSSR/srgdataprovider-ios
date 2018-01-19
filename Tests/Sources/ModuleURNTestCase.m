//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface ModuleURNTestCase : DataProviderBaseTestCase

@end

@implementation ModuleURNTestCase

#pragma mark Tests

- (void)testCreation
{
    NSString *URNString1 = @"urn:rts:module:event:cb1af673-7724-462b-923a-a60e7aee8437";
    SRGModuleURN *moduleURN1 = [[SRGModuleURN alloc] initWithURNString:URNString1];
    XCTAssertEqualObjects(moduleURN1.uid, @"cb1af673-7724-462b-923a-a60e7aee8437");
    XCTAssertNil(moduleURN1.sectionUid);
    XCTAssertEqualObjects(@(moduleURN1.moduleType), @(SRGModuleTypeEvent));
    XCTAssertEqualObjects(@(moduleURN1.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(moduleURN1.URNString, URNString1);
    
    NSString *URNString2 = @"urn:rts:module:event:cb1af673-7724-462b-923a-a60e7aee8437:400741a5-0289-474b-807c-01679a6986c0";
    SRGModuleURN *moduleURN2 = [[SRGModuleURN alloc] initWithURNString:URNString2];
    XCTAssertEqualObjects(moduleURN2.uid, @"cb1af673-7724-462b-923a-a60e7aee8437");
    XCTAssertEqualObjects(moduleURN2.sectionUid, @"400741a5-0289-474b-807c-01679a6986c0");
    XCTAssertEqualObjects(@(moduleURN2.moduleType), @(SRGModuleTypeEvent));
    XCTAssertEqualObjects(@(moduleURN2.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(moduleURN2.URNString, URNString2);
}

- (void)testCaseInsensitive
{
    SRGModuleURN *moduleURN1 = [[SRGModuleURN alloc] initWithURNString:@"URN:rts:module:event:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNotNil(moduleURN1);
    
    SRGModuleURN *moduleURN2 = [[SRGModuleURN alloc] initWithURNString:@"urn:RTS:module:event:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNotNil(moduleURN2);
    
    SRGModuleURN *moduleURN3 = [[SRGModuleURN alloc] initWithURNString:@"Urn:RTS:MODULE:EVENT:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNotNil(moduleURN3);
}

- (void)testCaseSensitive
{
    SRGModuleURN *moduleURN1 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:TeStUrN"];
    XCTAssertNotNil(moduleURN1);
    XCTAssertEqualObjects(moduleURN1.uid, @"TeStUrN");
    
    SRGModuleURN *moduleURN2 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:TeStUrN:SeCtIoNuRn"];
    XCTAssertNotNil(moduleURN2);
    XCTAssertEqualObjects(moduleURN2.uid, @"TeStUrN");
    XCTAssertEqualObjects(moduleURN2.sectionUid, @"SeCtIoNuRn");
}

- (void)testIncorrectURNs
{
    SRGModuleURN *moduleURN1 = [[SRGModuleURN alloc] initWithURNString:@"fakeURN:rts:module:event:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNil(moduleURN1);
    
    SRGModuleURN *moduleURN2 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:event:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNil(moduleURN2);
    
    SRGModuleURN *moduleURN3 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:"];
    XCTAssertNil(moduleURN3);
    
    SRGModuleURN *moduleURN4 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:dummy:event:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNil(moduleURN4);
    
    SRGModuleURN *moduleURN5 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:dummy:cb1af673-7724-462b-923a-a60e7aee8437"];
    XCTAssertNil(moduleURN5);
    
    SRGModuleURN *moduleURN6 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:cb1af673-7724-462b-923a-a60e7aee8437:"];
    XCTAssertNil(moduleURN6);
}

- (void)testEquality
{
    SRGModuleURN *moduleURN1 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1"];
    SRGModuleURN *moduleURN2 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1"];
    SRGModuleURN *moduleURN3 = [[SRGModuleURN alloc] initWithURNString:@"urn:srf:module:event:1"];
    SRGModuleURN *moduleURN4 = [[SRGModuleURN alloc] initWithURNString:@"urn:swi:show:radio:100"];
    SRGModuleURN *moduleURN5 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1:100"];
    SRGModuleURN *moduleURN6 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1:100"];
    SRGModuleURN *moduleURN7 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1:99"];
    
    XCTAssertTrue([moduleURN1 isEqual:moduleURN2]);
    XCTAssertFalse([moduleURN1 isEqual:moduleURN3]);
    XCTAssertFalse([moduleURN1 isEqual:moduleURN4]);
    XCTAssertFalse([moduleURN1 isEqual:moduleURN5]);
    XCTAssertTrue([moduleURN5 isEqual:moduleURN6]);
    XCTAssertFalse([moduleURN5 isEqual:moduleURN7]);
}

@end
