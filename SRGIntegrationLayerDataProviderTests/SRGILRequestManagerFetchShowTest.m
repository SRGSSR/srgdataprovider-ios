//
//  SRGILRequestManagerFetchShowTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Frédéric VERGEZ on 03/11/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SRGILDataProvider.h"
#import "SRGILURN.h"
#import "SRGILShow.h"

@interface SRGILRequestManagerFetchShowTest : XCTestCase

@end

@implementation SRGILRequestManagerFetchShowTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFetchVideoShowByIdentifier
{
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
    NSString *urnString = @"urn:srf:show:c38cc259-b5cd-4ac1-b901-e3fddd901a3d";
    SRGILURN *urn = [SRGILURN URNWithString:urnString];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid show object for the identifier %@",
                                       urnString]];
    
    SRGILRequestMediaCompletionBlock completionBlock = ^(SRGILShow *show, NSError *error) {
        if (error) {
            XCTFail(@"Could not fetch video Show");
        }
    
        XCTAssertNotNil(show, "Show must not be nil at this point");
        XCTAssertTrue([show.title isEqualToString:@"10vor10"], @"Show data seems incorrect (check title)");
        
        [expectation fulfill];
    };
    
    
    [dataProvider fetchShowWithURNString:[urn URNStringWithSeparator:@":"]
                         completionBlock:completionBlock];
    
    [self waitForExpectationsWithTimeout:300.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


- (void)testFetchAudioShowByIdentifier
{
    SRGILDataProvider *dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];
    NSString *urnString = @"urn:srf:show:d0d9378f-add4-4449-977f-71e52331472d";
    SRGILURN *urn = [SRGILURN URNWithString:urnString];
    
    XCTestExpectation *expectation = [self expectationWithDescription:
                                      [NSString stringWithFormat:@"Expected a valid show object for the identifier %@",
                                       urnString]];
    
    SRGILRequestMediaCompletionBlock completionBlock = ^(SRGILShow *show, NSError *error) {
        if (error) {
            XCTFail(@"Could not fetch audio Show");
        }
        
        XCTAssertNotNil(show, "Show must not be nil at this point");
        XCTAssertTrue([show.title isEqualToString:@"100 Sekunden Wissen"], @"Show data seems incorrect (check title)");
        XCTAssertNotNil(show.primaryChannelId, @"An audio show must have a channel id (when fetched alone)");
        
        [expectation fulfill];
    };
    
    
    [dataProvider fetchShowWithURNString:[urn URNStringWithSeparator:@":"]
                         completionBlock:completionBlock];
    
    [self waitForExpectationsWithTimeout:300.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}



@end
