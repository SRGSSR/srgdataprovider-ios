//
//  SRGILVideoTest.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 06/06/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"

#import "SRGILMedia.h"
#import "SRGILMedia+Private.h"

@interface SRGILMediaTest : XCTestCase
@property(nonatomic, strong) SRGILMedia *media;
@end

@implementation SRGILMediaTest

- (void)setUp
{
    [super setUp];
    self.media = [[SRGILMedia alloc] initWithDictionary:[self loadJSONFile:@"video_03" withClassName:@"Video"]];
}

- (void)tearDown
{
    [super tearDown];
    self.media = nil;
}

- (void)testCorrectInitMediaTypeFlag
{
    XCTAssertTrue([[self.media class] type] == SRGILMediaTypeUndefined, @"Media type should be undefined at this point.");
}

- (void)testCorrectInitLiveStreamFlag
{
    // The loaded JSON video is a full length RTS 19:30 article. It is NOT a live stream.
    XCTAssertFalse(self.media.isLiveStream, @"With correct input, this video must not be marked as a live stream.");
}

- (void)testCorrectInitFullStreamFlag
{
    XCTAssertTrue(self.media.isFullLength, @"With correct input, video must be marked as Full Length.");
}

- (void)testCorrectInitBlockedFlag
{
    XCTAssertFalse(self.media.isBlocked, @"With correct input, video must not be marked as blocked.");
}

- (void)testCorrectInitTitle
{
    XCTAssertNotNil(self.media.title, @"With correct input, video must have a title.");
}

- (void)testCorrectInitSubtitle
{
    XCTAssertNotNil(self.media.parentTitle, @"With correct input, video must have a parentTitle.");
}

- (void)testCorrectInitCreationDate
{
    XCTAssertNotNil(self.media.creationDate, @"With correct input, video must have a creationDate.");
}

- (void)testCorrectInitMarkIn
{
    XCTAssertEqual(self.media.markIn, 0.0, @"With correct input, video markIn must be = 0.0");
}

- (void)testCorrectInitMarkOut
{
    XCTAssertNotEqual(self.media.markOut, 0.0, @"With correct input, video markOut must be != 0.0");
}

- (void)testCorrectInitDuration
{
    XCTAssertEqual(self.media.duration, self.media.markOut-self.media.markIn, @"With correct input, video duration must be diff between markIn and markOut");
}

- (void)testPresenceOfSegment
{
    XCTAssertNotNil(self.media.segments, @"With correct input, segments must not be nil.");
}

- (void)testPresenceOfSegmentArray
{
    XCTAssertTrue([self.media.segments isKindOfClass:[NSArray class]], @"With correct input, segments must not be an array.");
}

- (void)testSegmentArrayCount
{
    XCTAssertTrue([self.media.segments count], @"With correct input, segments must not be an empty array.");
}

- (void)testSegmentsClass
{
    [self.media.segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue([obj isKindOfClass:[SRGILVideo class]],
                      @"With correct input, all segments must not be of SRGILVideo class.");
    }];
}

- (void)testPresenceOfHDURLforHLS
{
    XCTAssertNotNil(self.media.HDHLSURL, @"With correct input, there must be a HD HLS URL.");
}

- (void)testWrongInitWithNilDictionary
{
    XCTAssertNil([[SRGILMedia alloc] initWithDictionary:nil],
                 @"Init video with nil dictionary must return nil.");
}

- (void)testWrongInitWithNotADictionary
{
    XCTAssertThrows([[SRGILMedia alloc] initWithDictionary:(NSDictionary *)@"string"],
                    @"Init video with non-dictionary must throw an exception.");
}

- (void)testAssetSetForNormalVideo
{
    XCTAssertNotNil(self.media.assetSet, @"Asset set should not be nil.");
}

@end
