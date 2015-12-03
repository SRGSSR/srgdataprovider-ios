//
//  SRGFetchListsTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"
#import "SRGILModel.h"
#import "SRGILDataProvider.h"
#import "SRGILURLComponents.h"

@interface SRGFetchListsTest : XCTestCase
@property(nonatomic, strong) SRGILDataProvider *dataProvider;
@end

@implementation SRGFetchListsTest

- (void)setUp
{
    [super setUp];
    self.dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
}

- (void)tearDown
{
    self.dataProvider = nil;
    [super tearDown];
}

- (void)testFetchListTopics
{
    [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURLComponents *components = [SRGILURLComponents URLComponentsForFetchListIndex:SRGILFetchListVideoTopics
                                                                         withIdentifier:nil
                                                                                  error:nil];
    
    [self.dataProvider fetchObjectsListWithURLComponents:components
                                               organised:SRGILModelDataOrganisationTypeFlat
                                              onProgress:nil
                                            onCompletion:^(SRGILList * _Nullable items, Class  _Nullable __unsafe_unretained itemClass, NSError * _Nullable error) {
                                                [self fu]
                                            }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
