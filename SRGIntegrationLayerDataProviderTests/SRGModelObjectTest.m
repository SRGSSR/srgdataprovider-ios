//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"
#import "SRGILModelObject.h"

@interface SRGILModelObjectTest : XCTestCase
@end

@implementation SRGILModelObjectTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNSObjectInit
{
    XCTAssertThrows([[SRGILModelObject alloc] init], @"Normal init should throw an exception.");
}

- (void)testDefaultInitWithValidDictionary
{
    XCTAssertNotNil([[SRGILModelObject alloc] initWithDictionary:[self loadJSONFile:@"video_03" withClassName:@"Video"]],
                    @"Providing a valid dictionary should not return nil.");
}

@end
