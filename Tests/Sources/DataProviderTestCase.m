//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface DataProviderTestCase : DataProviderBaseTestCase

@end

@implementation DataProviderTestCase

#pragma mark Tests

- (void)testCreation
{
    NSURL *serviceURL = SRGIntegrationLayerProductionServiceURL();
    
    SRGDataProvider *dataProvider1 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitRTS];
    XCTAssertEqualObjects(dataProvider1.serviceURL, [NSURL URLWithString:@"https://il.srgssr.ch/"]);
    XCTAssertEqualObjects(dataProvider1.businessUnitIdentifier, SRGDataProviderBusinessUnitRTS);
    
    XCTAssertNil([SRGDataProvider currentDataProvider]);
    SRGDataProvider *previousDataProvider1 = [SRGDataProvider setCurrentDataProvider:dataProvider1];
    XCTAssertEqualObjects([SRGDataProvider currentDataProvider], dataProvider1);
    XCTAssertNil(previousDataProvider1);
    
    SRGDataProvider *dataProvider2 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitRSI];
    XCTAssertNotNil(dataProvider2);
    SRGDataProvider *previousDataProvider2 = [SRGDataProvider setCurrentDataProvider:dataProvider2];
    XCTAssertEqualObjects(previousDataProvider2, dataProvider1);
}

- (void)testDeallocation
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL() businessUnitIdentifier:SRGDataProviderBusinessUnitRTS];
    XCTAssertNil(dataProvider);
#pragma clang diagnostic pop
}

@end
