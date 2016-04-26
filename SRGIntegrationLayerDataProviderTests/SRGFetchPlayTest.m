//
//  SRGFetchPlayTest.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Pierre-Yves Bertholon on 26/04/16.
//  Copyright © 2016 SRG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SRGILDataProvider.h"
#import "SRGILURN.h"
#import "SRGILMedia.h"
#import "SRGILVideo.h"
#import "SRGILAudio.h"

static NSString *const SRFVideoURN = @"urn:srf:video:3b5ff803-6f32-4421-a736-d10ce35bf4b0";
static NSString *const SRFAudioURN = @"urn:srf:audio:e7cfd700-e14e-43b4-9710-3527fc2098bc";
static NSString *const SRFVideoSetURN = @"urn:srf:videoSet:91035074-f90e-472c-9bce-66bc3f114ff0";


@interface SRGFetchPlayTest : XCTestCase
@property(nonatomic, strong) SRGILDataProvider *dataProvider;
@end

@implementation SRGFetchPlayTest

- (void)setUp {
    [super setUp];
    self.dataProvider = [[SRGILDataProvider alloc] initWithBusinessUnit:@"srf"];}

- (void)tearDown {
    self.dataProvider = nil;
    [super tearDown];
}

- (void)testFetchVideo
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURN *videoURN = [SRGILURN URNWithString:SRFVideoURN];
    
    [self.dataProvider fetchMediaWithURN:videoURN
                         completionBlock:^(id  _Nullable media, NSError * _Nullable error) {
                             [expectation fulfill];
                             XCTAssertNil(error);
                             XCTAssertNotNil(media);
                             XCTAssertTrue([media isKindOfClass:[SRGILVideo class]]);
                         }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testFetchAudio
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURN *audioURN = [SRGILURN URNWithString:SRFAudioURN];
    
    [self.dataProvider fetchMediaWithURN:audioURN
                         completionBlock:^(id  _Nullable media, NSError * _Nullable error) {
                             [expectation fulfill];
                             XCTAssertNil(error);
                             XCTAssertNotNil(media);
                             XCTAssertTrue([media isKindOfClass:[SRGILAudio class]]);
                         }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testFetchVideoSet
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    SRGILURN *videoSetURN = [SRGILURN URNWithString:SRFVideoSetURN];
    
    [self.dataProvider fetchMediaWithURN:videoSetURN
                         completionBlock:^(id  _Nullable media, NSError * _Nullable error) {
                             [expectation fulfill];
                             XCTAssertNil(error);
                             XCTAssertNotNil(media);
                             XCTAssertTrue([media isKindOfClass:[SRGILVideo class]]);
                         }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

@end
