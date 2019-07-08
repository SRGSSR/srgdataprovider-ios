//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface MediaSearchSettingsTestCase : DataProviderBaseTestCase

@end

@implementation MediaSearchSettingsTestCase

#pragma mark Tests

- (void)testCopy
{
    SRGMediaSearchSettings *settings = [[SRGMediaSearchSettings alloc] init];
    settings.aggregationsEnabled = NO;
    settings.suggestionsEnabled = YES;
    settings.matchingOptions = SRGSearchMatchingOptionAny | SRGSearchMatchingOptionExact;
    settings.showURNs = @[ @"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660" ];
    settings.topicURNs = @[ @"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8" ];
    settings.mediaType = SRGMediaTypeVideo;
    settings.subtitlesAvailable = @YES;
    settings.downloadAvailable = @YES;
    settings.playableAbroad = @YES;
    settings.quality = SRGQualityHD;
    settings.minimumDurationInMinutes = @10.;
    settings.maximumDurationInMinutes = @60.;
    settings.afterDate = [NSDate dateWithTimeIntervalSince1970:0.];
    settings.beforeDate = NSDate.date;
    settings.sortCriterium = SRGSortCriteriumDate;
    settings.sortDirection = SRGSortDirectionAscending;
    
    SRGMediaSearchSettings *settingsCopy = [settings copy];
    XCTAssertEqual(settingsCopy.aggregationsEnabled, settings.aggregationsEnabled);
    XCTAssertEqual(settingsCopy.suggestionsEnabled, settings.suggestionsEnabled);
    XCTAssertEqual(settingsCopy.matchingOptions, settings.matchingOptions);
    XCTAssertEqualObjects(settingsCopy.showURNs, settings.showURNs);
    XCTAssertEqualObjects(settingsCopy.topicURNs, settings.topicURNs);
    XCTAssertEqual(settingsCopy.mediaType, settings.mediaType);
    XCTAssertEqual(settingsCopy.subtitlesAvailable, settings.subtitlesAvailable);
    XCTAssertEqual(settingsCopy.downloadAvailable, settings.downloadAvailable);
    XCTAssertEqual(settingsCopy.playableAbroad, settings.playableAbroad);
    XCTAssertEqual(settingsCopy.quality, settings.quality);
    XCTAssertEqualObjects(settingsCopy.minimumDurationInMinutes, settings.minimumDurationInMinutes);
    XCTAssertEqualObjects(settingsCopy.maximumDurationInMinutes, settings.maximumDurationInMinutes);
    XCTAssertEqualObjects(settingsCopy.afterDate, settings.afterDate);
    XCTAssertEqualObjects(settingsCopy.beforeDate, settings.beforeDate);
    XCTAssertEqual(settingsCopy.sortCriterium, settings.sortCriterium);
    XCTAssertEqual(settingsCopy.sortDirection, settings.sortDirection);
}

@end
