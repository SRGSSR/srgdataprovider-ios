//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSHTTPURLResponse+SRGDataProvider.h"

#import <XCTest/XCTest.h>

@interface NSHTTPURLResponse_DataProviderTestCase : XCTestCase

@end

@implementation NSHTTPURLResponse_DataProviderTestCase

#pragma mark Tests

- (void)testValues
{
    XCTAssertNotNil([NSHTTPURLResponse play_localizedStringForStatusCode:200]);
    
    XCTAssertNotNil([NSHTTPURLResponse play_localizedStringForStatusCode:404]);
    
    XCTAssertNotNil([NSHTTPURLResponse play_localizedStringForStatusCode:501]);
    XCTAssertNotNil([NSHTTPURLResponse play_localizedStringForStatusCode:502]);
    XCTAssertNotNil([NSHTTPURLResponse play_localizedStringForStatusCode:503]);
}

@end
