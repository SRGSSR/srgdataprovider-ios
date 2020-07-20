//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

// Private framework header
#import "SRGMediaSearchSettings+Private.h"

@interface MediaSearchSettingsTestCase : DataProviderBaseTestCase

@end

@implementation MediaSearchSettingsTestCase

#pragma mark Tests

- (void)testInstantiation
{
    SRGMediaSearchSettings *settings = [[SRGMediaSearchSettings alloc] init];
    XCTAssertTrue(settings.aggregationsEnabled);
    XCTAssertFalse(settings.suggestionsEnabled);
    XCTAssertEqual(settings.matchingOptions, 0);
    XCTAssertEqualObjects(settings.showURNs, NSSet.set);
    XCTAssertEqualObjects(settings.topicURNs, NSSet.set);
    XCTAssertEqual(settings.mediaType, SRGMediaTypeNone);
    XCTAssertNil(settings.subtitlesAvailable);
    XCTAssertNil(settings.downloadAvailable);
    XCTAssertNil(settings.playableAbroad);
    XCTAssertEqual(settings.quality, SRGQualityNone);
    XCTAssertNil(settings.minimumDurationInMinutes);
    XCTAssertNil(settings.maximumDurationInMinutes);
    XCTAssertNil(settings.fromDay);
    XCTAssertNil(settings.toDay);
    XCTAssertEqual(settings.sortCriterium, SRGSortCriteriumDefault);
    XCTAssertEqual(settings.sortDirection, SRGSortDirectionDescending);
}

- (void)testCopy
{
    SRGMediaSearchSettings *settings = [[SRGMediaSearchSettings alloc] init];
    settings.aggregationsEnabled = NO;
    settings.suggestionsEnabled = YES;
    settings.matchingOptions = SRGSearchMatchingOptionAny | SRGSearchMatchingOptionExact;
    settings.showURNs = [NSSet setWithObjects:@"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660", nil];
    settings.topicURNs = [NSSet setWithObjects:@"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8", nil];
    settings.mediaType = SRGMediaTypeVideo;
    settings.subtitlesAvailable = @YES;
    settings.downloadAvailable = @YES;
    settings.playableAbroad = @YES;
    settings.quality = SRGQualityHD;
    settings.minimumDurationInMinutes = @10.;
    settings.maximumDurationInMinutes = @60.;
    settings.fromDay = [SRGDay dayByAddingDays:-1 months:0 years:0 toDay:SRGDay.today];
    settings.toDay = SRGDay.today;
    settings.sortCriterium = SRGSortCriteriumDate;
    settings.sortDirection = SRGSortDirectionAscending;
    
    SRGMediaSearchSettings *settingsCopy = settings.copy;
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
    XCTAssertEqualObjects(settingsCopy.fromDay, settings.fromDay);
    XCTAssertEqualObjects(settingsCopy.toDay, settings.toDay);
    XCTAssertEqual(settingsCopy.sortCriterium, settings.sortCriterium);
    XCTAssertEqual(settingsCopy.sortDirection, settings.sortDirection);
    
    XCTAssertEqualObjects(settingsCopy.queryItems, settings.queryItems);
}

- (void)testEqual
{
    SRGMediaSearchSettings *settings1 = [[SRGMediaSearchSettings alloc] init];
    SRGMediaSearchSettings *settings2 = [[SRGMediaSearchSettings alloc] init];
    
    XCTAssertEqualObjects(settings1, settings2);
    
    SRGDay *fromDay = [SRGDay dayByAddingDays:-1 months:0 years:0 toDay:SRGDay.today];
    SRGDay *toDay = SRGDay.today;
    
    SRGMediaSearchSettings *settings3 = [[SRGMediaSearchSettings alloc] init];
    settings3.aggregationsEnabled = NO;
    settings3.suggestionsEnabled = YES;
    settings3.matchingOptions = SRGSearchMatchingOptionAny | SRGSearchMatchingOptionExact;
    settings3.showURNs = [NSSet setWithObjects:@"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660", nil];
    settings3.topicURNs = [NSSet setWithObjects:@"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8", nil];
    settings3.mediaType = SRGMediaTypeVideo;
    settings3.subtitlesAvailable = @YES;
    settings3.downloadAvailable = @YES;
    settings3.playableAbroad = @YES;
    settings3.quality = SRGQualityHD;
    settings3.minimumDurationInMinutes = @10.;
    settings3.maximumDurationInMinutes = @60.;
    settings3.fromDay = fromDay;
    settings3.toDay = toDay;
    settings3.sortCriterium = SRGSortCriteriumDate;
    settings3.sortDirection = SRGSortDirectionAscending;
    
    SRGMediaSearchSettings *settings4 = [[SRGMediaSearchSettings alloc] init];
    settings4.aggregationsEnabled = NO;
    settings4.suggestionsEnabled = YES;
    settings4.matchingOptions = SRGSearchMatchingOptionAny | SRGSearchMatchingOptionExact;
    settings4.showURNs = [NSSet setWithObjects:@"urn:rsi:show:tv:3566695", @"urn:rsi:show:tv:9376660", nil];
    settings4.topicURNs = [NSSet setWithObjects:@"urn:rsi:topic:tv:7", @"urn:rsi:topic:tv:8", nil];
    settings4.mediaType = SRGMediaTypeVideo;
    settings4.subtitlesAvailable = @YES;
    settings4.downloadAvailable = @YES;
    settings4.playableAbroad = @YES;
    settings4.quality = SRGQualityHD;
    settings4.minimumDurationInMinutes = @10.;
    settings4.maximumDurationInMinutes = @60.;
    settings4.fromDay = fromDay;
    settings4.toDay = toDay;
    settings4.sortCriterium = SRGSortCriteriumDate;
    settings4.sortDirection = SRGSortDirectionAscending;
    
    XCTAssertEqualObjects(settings3, settings4);
    
    XCTAssertEqualObjects(settings3.queryItems, settings4.queryItems);
    
    SRGMediaSearchSettings *settings5 = settings4.copy;
    settings5.aggregationsEnabled = YES;
    
    XCTAssertNotEqualObjects(settings3, settings5);
    XCTAssertNotEqualObjects(settings4, settings5);
    
    XCTAssertNotEqualObjects(settings3.queryItems, settings5.queryItems);
    XCTAssertNotEqualObjects(settings4.queryItems, settings5.queryItems);
}

@end
