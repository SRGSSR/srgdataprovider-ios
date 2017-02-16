//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

@interface ErrorTestCase : XCTestCase

@end

@implementation ErrorTestCase

- (void)testBlockingError
{
    NSError *error1 = SRGErrorForBlockingReason(SRGBlockingReasonLegal);
    XCTAssertEqualObjects(error1.domain, SRGDataProviderErrorDomain);
    XCTAssertEqual(error1.code, SRGDataProviderErrorBlocked);
    
    NSError *error2 = SRGErrorForBlockingReason(SRGBlockingReasonNone);
    XCTAssertNil(error2);
}

@end
