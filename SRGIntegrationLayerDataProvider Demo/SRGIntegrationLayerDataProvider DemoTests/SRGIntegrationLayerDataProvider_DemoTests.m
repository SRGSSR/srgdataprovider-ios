//
//  SRGIntegrationLayerDataProvider_DemoTests.m
//  SRGIntegrationLayerDataProvider DemoTests
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

static NSArray *dynamicValueKeys = nil;

@interface SRGIntegrationLayerDataProvider_DemoTests : KIFTestCase

@end

@implementation SRGIntegrationLayerDataProvider_DemoTests

- (void)setUp
{
    [super setUp];
    
    if (!dynamicValueKeys) {
        dynamicValueKeys = @[@"ns_ap_cs", @"ns_st_bp", @"ns_ap_id", @"ns_st_po", @"ns_st_br", @"ns_ts", @"ns_st_bt", @"ns_st_id"];
    }
}


- (void)testComScoreMeasurementsOnValidVideoAtRow5
{
    // Row 5: Geopolitis du 23 mai 2015.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSString *indexPathKey = @"indexPath-row-0-section-1";
    
    NSString *refLabelsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RTSVideosAnalyticsLabels" ofType:@"plist"];
    NSDictionary *refLabelsDict = [NSDictionary dictionaryWithContentsOfFile:refLabelsPath];
    
    if (refLabelsDict[indexPathKey]) {
    
        [tester tapRowAtIndexPath:indexPath inTableViewWithAccessibilityIdentifier:@"tableView"];
    
        NSNotification *notification = [system waitForNotificationName:@"RTSAnalyticsComScoreRequestDidFinish" object:nil];
        NSDictionary *labels = notification.userInfo[@"RTSAnalyticsLabels"];
    
        NSDictionary *refLabels = refLabelsDict[indexPathKey];
        [refLabels enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            if ([dynamicValueKeys containsObject:key]) {
                XCTAssertNotNil(labels[key], @"Missing value for key '%@'.", key);
            }
            else {
                XCTAssertEqualObjects(labels[key], value, @"Wrong value --%@-- expected --%@-- for key '%@'.", labels[key], value, key);
            }
        }];
    }
}

@end
