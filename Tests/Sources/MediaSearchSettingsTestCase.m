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

- (void)testEqual
{
    SRGMediaSearchSettings *settings1 = [[SRGMediaSearchSettings alloc] init];
    SRGMediaSearchSettings *settings2 = [[SRGMediaSearchSettings alloc] init];
    
    XCTAssertEqualObjects(settings1, settings2);
    
    NSDate *afterDate = [NSDate dateWithTimeIntervalSince1970:0.];
    NSDate *beforeDate = NSDate.date;
    
    SRGMediaSearchSettings *settings3 = [[SRGMediaSearchSettings alloc] init];
    settings3.aggregationsEnabled = NO;
    settings3.suggestionsEnabled = YES;
    settings3.matchingOptions = SRGSearchMatchingOptionAny | SRGSearchMatchingOptionExact;
    settings3.showURNs = @[ @"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660" ];
    settings3.topicURNs = @[ @"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8" ];
    settings3.mediaType = SRGMediaTypeVideo;
    settings3.subtitlesAvailable = @YES;
    settings3.downloadAvailable = @YES;
    settings3.playableAbroad = @YES;
    settings3.quality = SRGQualityHD;
    settings3.minimumDurationInMinutes = @10.;
    settings3.maximumDurationInMinutes = @60.;
    settings3.afterDate = afterDate;
    settings3.beforeDate = beforeDate;
    settings3.sortCriterium = SRGSortCriteriumDate;
    settings3.sortDirection = SRGSortDirectionAscending;
    
    SRGMediaSearchSettings *settings4 = [[SRGMediaSearchSettings alloc] init];
    settings4.aggregationsEnabled = NO;
    settings4.suggestionsEnabled = YES;
    settings4.matchingOptions = SRGSearchMatchingOptionAny | SRGSearchMatchingOptionExact;
    settings4.showURNs = @[ @"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660" ];
    settings4.topicURNs = @[ @"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8" ];
    settings4.mediaType = SRGMediaTypeVideo;
    settings4.subtitlesAvailable = @YES;
    settings4.downloadAvailable = @YES;
    settings4.playableAbroad = @YES;
    settings4.quality = SRGQualityHD;
    settings4.minimumDurationInMinutes = @10.;
    settings4.maximumDurationInMinutes = @60.;
    settings4.afterDate = afterDate;
    settings4.beforeDate = beforeDate;
    settings4.sortCriterium = SRGSortCriteriumDate;
    settings4.sortDirection = SRGSortDirectionAscending;
    
    XCTAssertEqualObjects(settings3, settings4);
    
    SRGMediaSearchSettings *settings5 = [settings4 copy];
    settings5.aggregationsEnabled = YES;
    
    XCTAssertNotEqualObjects(settings3, settings5);
    XCTAssertNotEqualObjects(settings4, settings5);
}

@end
