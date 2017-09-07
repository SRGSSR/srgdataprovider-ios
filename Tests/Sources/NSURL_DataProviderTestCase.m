//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSHTTPURLResponse+SRGDataProvider.h"

#import "NSURL+SRGDataProvider.h"

#import <XCTest/XCTest.h>

@interface NSURL_DataProviderTestCase : XCTestCase

@end

@implementation NSURL_DataProviderTestCase

#pragma mark Tests

- (void)testImageScaleWidth
{
    
    NSURL *imageURL = [NSURL URLWithString:@"https://ws.srf.ch/asset/image/audio/a13774c4-eba2-4b93-9114-e6c8992471ad/EPISODE_IMAGE/1462435209.png"];
    NSURL *scaledImageURL = [imageURL srg_URLForDimension:SRGImageDimensionWidth
                                                withValue:400.f
                                                      uid:nil
                                                     type:SRGImageTypeDefault];
    XCTAssertNotNil(scaledImageURL);
    
    NSArray<NSString *> *pathComponents = scaledImageURL.pathComponents;
    XCTAssertTrue([scaledImageURL.absoluteString containsString:imageURL.absoluteString]);
    XCTAssertTrue([pathComponents[pathComponents.count - 3] isEqualToString:@"scale"]);
    XCTAssertTrue([pathComponents[pathComponents.count - 2] isEqualToString:@"width"]);
    XCTAssertTrue([pathComponents.lastObject isEqualToString:@"400"]);
}

- (void)testImageScaleHeight
{
    
    NSURL *imageURL = [NSURL URLWithString:@"https://ws.srf.ch/asset/image/audio/a13774c4-eba2-4b93-9114-e6c8992471ad/EPISODE_IMAGE/1462435209.png"];
    NSURL *scaledImageURL = [imageURL srg_URLForDimension:SRGImageDimensionHeight
                                                withValue:300.f
                                                      uid:nil
                                                     type:SRGImageTypeDefault];
    XCTAssertNotNil(scaledImageURL);
    
    NSArray<NSString *> *pathComponents = scaledImageURL.pathComponents;
    XCTAssertTrue([scaledImageURL.absoluteString containsString:imageURL.absoluteString]);
    XCTAssertTrue([pathComponents[pathComponents.count - 3] isEqualToString:@"scale"]);
    XCTAssertTrue([pathComponents[pathComponents.count - 2] isEqualToString:@"height"]);
    XCTAssertTrue([pathComponents.lastObject isEqualToString:@"300"]);
}

- (void)testImageNoScaleWidth
{
    
    NSURL *imageURL = [NSURL URLWithString:@"https://www.srf.ch/static/radio/modules/data/pictures/srf-4/international/2017/09-2017/481100.170906_echo_nordkorea_milliarden_rakete-624.jpg"];
    NSURL *scaledImageURL = [imageURL srg_URLForDimension:SRGImageDimensionWidth
                                                withValue:400.f
                                                      uid:nil
                                                     type:SRGImageTypeDefault];
    XCTAssertNotNil(scaledImageURL);
    
    NSArray<NSString *> *pathComponents = scaledImageURL.pathComponents;
    XCTAssertTrue([scaledImageURL.absoluteString containsString:imageURL.absoluteString]);
    XCTAssertFalse([pathComponents[pathComponents.count - 3] isEqualToString:@"scale"]);
    XCTAssertFalse([pathComponents[pathComponents.count - 2] isEqualToString:@"width"]);
    XCTAssertFalse([pathComponents.lastObject isEqualToString:@"400"]);
}

- (void)testImageNoScaleHeight
{
    
    NSURL *imageURL = [NSURL URLWithString:@"https://www.srf.ch/static/radio/modules/data/pictures/srf-4/international/2017/09-2017/481100.170906_echo_nordkorea_milliarden_rakete-624.jpg"];
    NSURL *scaledImageURL = [imageURL srg_URLForDimension:SRGImageDimensionHeight
                                                withValue:300.f
                                                      uid:nil
                                                     type:SRGImageTypeDefault];
    XCTAssertNotNil(scaledImageURL);
    
    NSArray<NSString *> *pathComponents = scaledImageURL.pathComponents;
    XCTAssertTrue([scaledImageURL.absoluteString containsString:imageURL.absoluteString]);
    XCTAssertFalse([pathComponents[pathComponents.count - 3] isEqualToString:@"scale"]);
    XCTAssertFalse([pathComponents[pathComponents.count - 2] isEqualToString:@"height"]);
    XCTAssertFalse([pathComponents.lastObject isEqualToString:@"300"]);
}

- (void)testImageScaleWidthThroughApigee
{
    
    NSURL *imageURL = [NSURL URLWithString:@"https://srgssr-prod.apigee.net/image-play-scale/http://www.srf.ch/static/radio/modules/data/pictures/srf-4/international/2017/09-2017/481100.170906_echo_nordkorea_milliarden_rakete-624.jpg"];
    NSURL *scaledImageURL = [imageURL srg_URLForDimension:SRGImageDimensionWidth
                                                withValue:400.f
                                                      uid:nil
                                                     type:SRGImageTypeDefault];
    XCTAssertNotNil(scaledImageURL);
    
    NSArray<NSString *> *pathComponents = scaledImageURL.pathComponents;
    XCTAssertTrue([scaledImageURL.absoluteString containsString:imageURL.absoluteString]);
    XCTAssertTrue([pathComponents[pathComponents.count - 3] isEqualToString:@"scale"]);
    XCTAssertTrue([pathComponents[pathComponents.count - 2] isEqualToString:@"width"]);
    XCTAssertTrue([pathComponents.lastObject isEqualToString:@"400"]);
}

- (void)testImageScaleHeightThroughApigee
{
    
    NSURL *imageURL = [NSURL URLWithString:@"https://srgssr-prod.apigee.net/image-play-scale/http://www.srf.ch/static/radio/modules/data/pictures/srf-4/international/2017/09-2017/481100.170906_echo_nordkorea_milliarden_rakete-624.jpg"];
    NSURL *scaledImageURL = [imageURL srg_URLForDimension:SRGImageDimensionHeight
                                                withValue:300.f
                                                      uid:nil
                                                     type:SRGImageTypeDefault];
    XCTAssertNotNil(scaledImageURL);
    
    NSArray<NSString *> *pathComponents = scaledImageURL.pathComponents;
    XCTAssertTrue([scaledImageURL.absoluteString containsString:imageURL.absoluteString]);
    XCTAssertTrue([pathComponents[pathComponents.count - 3] isEqualToString:@"scale"]);
    XCTAssertTrue([pathComponents[pathComponents.count - 2] isEqualToString:@"height"]);
    XCTAssertTrue([pathComponents.lastObject isEqualToString:@"300"]);
}

@end
