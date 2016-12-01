//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDataProvider/SRGDataProvider.h>
#import <XCTest/XCTest.h>

@interface DataProviderTests : XCTestCase

@end

@implementation DataProviderTests

- (void)testCreation
{
    NSURL *serviceURL = [NSURL URLWithString:@"https://il-test.srgssr.ch"];
    
    SRGDataProvider *dataProvider1 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
    XCTAssertEqualObjects(dataProvider1.serviceURL, [NSURL URLWithString:@"https://il-test.srgssr.ch/"]);
    XCTAssertEqualObjects(dataProvider1.businessUnitIdentifier, SRGDataProviderBusinessUnitIdentifierRTS);
    
    XCTAssertNil([SRGDataProvider currentDataProvider]);
    SRGDataProvider *previousDataProvider1 = [SRGDataProvider setCurrentDataProvider:dataProvider1];
    XCTAssertEqualObjects([SRGDataProvider currentDataProvider], dataProvider1);
    XCTAssertNil(previousDataProvider1);
    
    SRGDataProvider *dataProvider2 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRSI];
    XCTAssertNotNil(dataProvider2);
    SRGDataProvider *previousDataProvider2 = [SRGDataProvider setCurrentDataProvider:dataProvider2];
    XCTAssertEqualObjects(previousDataProvider2, dataProvider1);
}

@end
