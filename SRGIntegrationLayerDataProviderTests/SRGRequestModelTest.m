//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "XCTestCase+JSON.h"

#import "SRGILImageRepresentation.h"
#import "SRGILVideo.h"
#import "SRGILImage.h"
#import "SRGILAssetMetadata.h"
#import "SRGILAssetSet.h"
#import "SRGILShow.h"
#import "SRGILPlaylist.h"

/**
 * Unit tests for Integration Layer Communication model classes.
 */
@interface SRGRequestModelTest : XCTestCase

@end

@implementation SRGRequestModelTest

- (void)testSRGILAssetMetadata
{
    SRGILAssetMetadata *assetMetadata = [[SRGILAssetMetadata alloc] initWithDictionary:[self loadJSONFile:@"assetmetadata_01" withClassName:nil]];
    XCTAssertNotNil(assetMetadata, @"Could not format/create object");
    XCTAssertTrue([assetMetadata.title isEqualToString:@"Sport dernière"], @"Incorrect field value: %@", assetMetadata.title);
}

- (void)testSRGILAssetSet
{
    SRGILAssetSet *assetSet = [[SRGILAssetSet alloc] initWithDictionary:[self loadJSONFile:@"assetset_01" withClassName:nil]];
    XCTAssertNotNil(assetSet, @"Could not format/create object");
    XCTAssertTrue(assetSet.show != nil || assetSet.rubric != nil, @"Could not get show or rubric object");
}

- (void)testSRGILRubric
{
    SRGILRubric *rubric = [[SRGILRubric alloc] initWithDictionary:[self loadJSONFile:@"rubric_01" withClassName:nil]];
    
    XCTAssertNotNil(rubric, @"Could not format/create object");
    XCTAssertNotNil(rubric.image, @"Could not get image object");
    XCTAssertTrue([rubric.title isEqualToString:@"Programmhinweis"], @"Invalid title field");
}

- (void)testSRGILShow
{
    SRGILShow *show = [[SRGILShow alloc] initWithDictionary:[self loadJSONFile:@"show_01" withClassName:nil]];
    XCTAssertNotNil(show, @"Could not format/create object");
    XCTAssertNotNil(show.image, @"Could not get image object");
    XCTAssertTrue([show.title isEqualToString:@"SRF Meteo"], @"Invalid title field");
}

- (void)testSRGILVideo01
{
    SRGILVideo *video = [[SRGILVideo alloc] initWithDictionary:[self loadJSONFile:@"video_01" withClassName:@"Video"]];
    
    XCTAssertNotNil(video, @"Could not format/create object");
    
    XCTAssertNotNil(video.assetSet, @"No asset set found");
    XCTAssertTrue([video.urnString isEqualToString:@"urn:srf:ais:video:acb62d54-4bb2-480d-a88e-c05a424ff34e"], @"Bad video uid: %@", video.urnString);
    XCTAssertTrue(video.fullLength, @"Bad full length value");
    XCTAssertTrue([video.assetMetadatas count] == 1, @"Bad asset metadata size");
    XCTAssertTrue([video.title isEqualToString:@"Reporter vom 02.02.2014"], @"Bad video title");
    /* Must call play service (see video 2)
    XCTAssertTrue([[video.thumbnailURL absoluteString] isEqualToString:@"http://srfcdn.www-stage-relaunch.tp.sf.tv/asset/image/audio/abbfd6a8-b012-4af5-92f4-d551bfad480b/HEADER_SRF_PLAYER.jpg"],
                  @"Bad thumbnail for video: %@", video.thumbnailURL);
     */
    XCTAssertTrue(0.0f == video.markIn, @"Bad markIn");
    // Markin / markout now in seconds
    XCTAssertTrue(1.34904 == video.markOut, @"Bad markOut: %f", video.markOut);
    XCTAssertTrue(1.34904 == video.duration, @"Bad duration: %f", video.duration);
    XCTAssertTrue([video.parentTitle isEqualToString:@"Reporter"], @"Bad parent title");
}

// Testing hlsURL fiels
- (void)testSRGILVideo02
{
    SRGILVideo *video = [[SRGILVideo alloc] initWithDictionary:[self loadJSONFile:@"video_02" withClassName:@"Video"]];
    
    XCTAssertNotNil(video, @"Could not format/create object");
    
    XCTAssertTrue([[video.HDHLSURL absoluteString] isEqualToString:@"http://stream-i.rts.ch/i/meteo/2014/meteo_20140320_full_f_777781-,101,251,701,1201,k.mp4.csmil/master.m3u8"],
                  @"Bad HD HLS stream url for video: %@", video.HDHLSURL);
    
    // No SD in this case:
    XCTAssertNil(video.SDHLSURL, @"Bad SD HLS stream url for video: %@", [video.SDHLSURL absoluteString]);    
}

- (void)testSRGILVideoPlaylists
{
    SRGILVideo *video = [[SRGILVideo alloc] initWithDictionary:[self loadJSONFile:@"video_02" withClassName:@"Video"]];
    
    XCTAssertNotNil(video, @"Could not format/create object");

    XCTAssertTrue(2 == [video.playlists count], @"Bad number of playlists");
    
    SRGILPlaylist *playlist1 = video.playlists[0];
    SRGILPlaylist *playlist2 = video.playlists[1];

    XCTAssertTrue([[[playlist1 URLForQuality:SRGILPlaylistURLQualityHD] absoluteString] isEqualToString: @"http://rtsww-f.akamaihd.net/z/meteo/2014/meteo_20140320_full_f_777781-,101,251,701,1201,k.mp4.csmil/manifest.f4m"],
                  @"Bad default URL" );
    
    XCTAssertTrue(playlist1.protocol == SRGILPlaylistProtocolHDS, @"Bad protocol");
    
    XCTAssertTrue([[[playlist2 URLForQuality:SRGILPlaylistURLQualityHD] absoluteString] isEqualToString: @"http://stream-i.rts.ch/i/meteo/2014/meteo_20140320_full_f_777781-,101,251,701,1201,k.mp4.csmil/master.m3u8"],
                  @"Bad default URL" );
    XCTAssertTrue(playlist2.protocol == SRGILPlaylistProtocolHLS, @"Bad protocol");
}

- (void)testSRFModelObjectWithBadDictionary
{
    id bang = [NSArray array];
    
    // Any kind of SRG Object will do:
    SRGILImage *image;
    XCTAssertThrows(image = [[SRGILImage alloc] initWithDictionary:bang], @"Must throw an exception when passing bad type of parameters.");
}


- (void)testSRGILVideoIsLiveStream
{
    SRGILVideo *liveVideo = [[SRGILVideo alloc] initWithDictionary:[self loadJSONFile:@"livevideo01" withClassName:@"Video"]];
    XCTAssertNotNil(liveVideo, @"Could not format/create object");
    XCTAssert(liveVideo.isLiveStream, @"This video is a livestream");
}


@end
