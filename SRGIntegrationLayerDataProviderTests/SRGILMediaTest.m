//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+JSON.h"

#import "SRGILMedia.h"
#import "SRGILVideo.h"
#import "SRGILDownload.h"

@interface SRGILMediaTest : XCTestCase
@property(nonatomic, strong) SRGILMedia *media;
@property(nonatomic, strong) SRGILMedia *downloadableMedia;
@end

@implementation SRGILMediaTest

- (void)setUp
{
    [super setUp];
    self.media = [[SRGILMedia alloc] initWithDictionary:[self loadJSONFile:@"video_03" withClassName:@"Video"]];
    self.downloadableMedia = [[SRGILMedia alloc] initWithDictionary:[self loadJSONFile:@"video_download_srf_01" withClassName:@"Video"]];
}

- (void)tearDown
{
    [super tearDown];
    self.media = nil;
}

- (void)testPresenceOfKeyMethodUsedInAssetInitialization
{
    XCTAssertTrue([SRGILMedia instancesRespondToSelector:@selector(compareMarkInTimes:)]);
}

- (void)testCorrectInitMediaTypeFlag
{
    XCTAssertTrue([self.media type] == SRGILMediaTypeUndefined, @"Media type should be undefined at this point.");
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
    XCTAssertNotNil([self.media contentURLForPlaylistWithProtocol:SRGILPlaylistProtocolHLS withQuality:SRGILPlaylistURLQualityHD],
                    @"With correct input, there must be a HD HLS URL.");
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

- (void)testDownloadForValidVideo
{
    XCTAssertNotNil(self.downloadableMedia.downloads, @"Downloads should not be nil.");
    XCTAssertTrue([self.downloadableMedia.downloads count] == 1, @"There should be only one.");
    SRGILDownload *download = self.downloadableMedia.downloads.lastObject;
    XCTAssertNotNil([download URLForQuality:SRGILDownloadURLQualitySD], @"There should be an URL for that quality");
}

@end
