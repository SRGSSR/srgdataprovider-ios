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
    XCTAssertEqualObjects(dataProvider1.serviceURL, [NSURL URLWithString:@"https://il.srgssr.ch/integrationlayer/"]);
    
    XCTAssertNil(SRGDataProvider.currentDataProvider);
    SRGDataProvider.currentDataProvider = dataProvider1;
    XCTAssertEqualObjects(SRGDataProvider.currentDataProvider, dataProvider1);
    
    SRGDataProvider *dataProvider2 = [[SRGDataProvider alloc] initWithServiceURL:serviceURL];
    XCTAssertNotNil(dataProvider2);
    SRGDataProvider.currentDataProvider = dataProvider2;
    XCTAssertEqualObjects(SRGDataProvider.currentDataProvider, dataProvider2);
}

- (void)testDeallocation
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    __weak SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:SRGIntegrationLayerProductionServiceURL()];
    XCTAssertNil(dataProvider);
#pragma clang diagnostic pop
}

@end
