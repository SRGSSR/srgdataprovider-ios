//
//  SRGLiveStreamVideoTest.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 16/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"

#import "SRGILVideo.h"

@interface SRGLiveStreamVideoTest : XCTestCase
@property(nonatomic, strong) SRGILVideo *video;
@end

@implementation SRGLiveStreamVideoTest

- (void)setUp
{
    [super setUp];
    self.video = [[SRGILVideo alloc] initWithDictionary:[self loadJSONFile:@"livevideo01" withClassName:@"Video"]];
}

- (void)tearDown
{
    [super tearDown];
    self.video = nil;
}

- (void)testCorrectInitLiveStreamFlag
{
    // The loaded JSON video is a full length RTS 19:30 article. It is NOT a live stream.
    XCTAssertTrue(self.video.isLiveStream, @"With correct input, this video must not be marked as a live stream.");
}

- (void)testCorrectInitFullStreamFlag
{
    XCTAssertFalse(self.video.isFullLength, @"With correct input, video must be marked as Full Length.");
}

- (void)testCorrectInitBlockedFlag
{
    XCTAssertFalse(self.video.isBlocked, @"With correct input, video must not be marked as blocked.");
}

- (void)testCorrectInitTitle
{
    XCTAssertNotNil(self.video.title, @"With correct input, video must have a title.");
}

- (void)testCorrectParentSubtitle
{
    XCTAssertNotNil(self.video.parentTitle, @"With correct input, video must have a parentTitle.");
}

- (void)testCorrectCreationDate
{
    XCTAssertNotNil(self.video.creationDate, @"With correct input, video must have a creationDate.");
}

- (void)testCorrectInitMarkIn
{
    XCTAssertEqual(self.video.markIn, 0.0, @"With correct input, video markIn must be = 0.0");
}

- (void)testCorrectInitMarkOut
{
    XCTAssertEqual(self.video.markOut, 0.0, @"With correct input, video markOut must be != 0.0");
}

- (void)testCorrectInitDuration
{
    XCTAssertEqual(self.video.duration, 0, @"With correct input, video duration must be 0");
}

- (void)testPresenceOfSingleDuplicateSegment
{
    XCTAssertEqual(self.video.segments.count, 1, @"With correct input, segments must not be nil.");
    XCTAssertEqualObjects(self.video.urnString, [(SRGILVideo *)self.video.segments.firstObject urnString], @"Wrong segment");
}

- (void)testSegmentsClass
{
    [self.video.segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue([obj isKindOfClass:[SRGILVideo class]],
                      @"With correct input, all segments must not be of SRGILVideo class.");
    }];
}

- (void)testPresenceOfHDURLforHLS
{
    XCTAssertNotNil(self.video.HDHLSURL, @"With correct input, there must be a HD HLS URL.");
}

- (void)testPresenceOfSDURLforHLS
{
//    XCTAssertNotNil(v.SDHLSURL, @"With correct input, there must be a SD HLS URL.");
}

- (void)testWrongInitWithNilDictionary
{
    XCTAssertNil([[SRGILVideo alloc] initWithDictionary:nil],
                 @"Init video with nil dictionary must return nil.");
}

- (void)testWrongInitWithNotADictionary
{
    XCTAssertThrows([[SRGILVideo alloc] initWithDictionary:(NSDictionary *)@"string"],
                    @"Init video with non-dictionary must throw an exception.");
}

- (void)testAssetSetForNormalVideo
{
    XCTAssertNotNil(self.video.assetSet, @"Asset set should not be nil.");
}

@end
