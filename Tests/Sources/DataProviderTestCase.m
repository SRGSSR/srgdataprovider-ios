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
    
    SRGDataProvider *dataProvider1 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL];
    XCTAssertEqualObjects(dataProvider1.serviceURL, [NSURL URLWithString:@"https://il.srgssr.ch/"]);
    
    XCTAssertNil([SRGDataProvider currentDataProvider]);
    SRGDataProvider *previousDataProvider1 = [SRGDataProvider setCurrentDataProvider:dataProvider1];
    XCTAssertEqualObjects([SRGDataProvider currentDataProvider], dataProvider1);
    XCTAssertNil(previousDataProvider1);
    
    SRGDataProvider *dataProvider2 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL];
    XCTAssertNotNil(dataProvider2);
    SRGDataProvider *previousDataProvider2 = [SRGDataProvider setCurrentDataProvider:dataProvider2];
    XCTAssertEqualObjects(previousDataProvider2, dataProvider1);
}

- (void)testDeallocation
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    XCTAssertNil(dataProvider);
#pragma clang diagnostic pop
}

- (void)testBusinessUnitForVendor
{
    XCTAssertEqualObjects(SRGDataProviderBusinessUnitForVendor(SRGVendorRSI), SRGDataProviderBusinessUnitRSI);
    XCTAssertEqualObjects(SRGDataProviderBusinessUnitForVendor(SRGVendorRTR), SRGDataProviderBusinessUnitRTR);
    XCTAssertEqualObjects(SRGDataProviderBusinessUnitForVendor(SRGVendorRTS), SRGDataProviderBusinessUnitRTS);
    XCTAssertEqualObjects(SRGDataProviderBusinessUnitForVendor(SRGVendorSRF), SRGDataProviderBusinessUnitSRF);
    XCTAssertEqualObjects(SRGDataProviderBusinessUnitForVendor(SRGVendorSWI), SRGDataProviderBusinessUnitSWI);
    XCTAssertNil(SRGDataProviderBusinessUnitForVendor(SRGVendorTVO));
    XCTAssertNil(SRGDataProviderBusinessUnitForVendor(SRGVendorCanalAlpha));
}

@end
