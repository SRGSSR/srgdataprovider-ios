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
    NSString *URNString = @"urn:rts:module:event:cb1af673-7724-462b-923a-a60e7aee8437";
    
    SRGModuleURN *moduleURN = [[SRGModuleURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(moduleURN.uid, @"cb1af673-7724-462b-923a-a60e7aee8437");
    XCTAssertEqualObjects(@(moduleURN.moduleType), @(SRGModuleTypeEvent));
    XCTAssertEqualObjects(@(moduleURN.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(moduleURN.URNString, URNString);
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
    SRGModuleURN *moduleURN = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:TeStUrN"];
    XCTAssertNotNil(moduleURN);
    XCTAssertEqualObjects(moduleURN.uid, @"TeStUrN");
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
}

- (void)testEquality
{
    SRGModuleURN *moduleURN1 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1"];
    SRGModuleURN *moduleURN2 = [[SRGModuleURN alloc] initWithURNString:@"urn:rts:module:event:1"];
    SRGModuleURN *moduleURN3 = [[SRGModuleURN alloc] initWithURNString:@"urn:srf:module:event:1"];
    SRGModuleURN *moduleURN4 = [[SRGModuleURN alloc] initWithURNString:@"urn:swi:show:radio:100"];
    
    XCTAssertTrue([moduleURN1 isEqual:moduleURN2]);
    XCTAssertFalse([moduleURN1 isEqual:moduleURN3]);
    XCTAssertFalse([moduleURN1 isEqual:moduleURN4]);
}

@end
