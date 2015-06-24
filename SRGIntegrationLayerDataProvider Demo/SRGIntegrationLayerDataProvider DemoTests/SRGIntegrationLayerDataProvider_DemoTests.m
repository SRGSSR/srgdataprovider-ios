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
        dynamicValueKeys = @[@"ns_ap_cs", @"ns_st_bp", @"ns_st_pv", @"ns_ap_id", @"ns_st_po", @"ns_st_br", @"ns_ts",
                             @"ns_st_bt", @"ns_st_id", @"ns_ap_ec", @"ns_st_cu", @"ns_st_mv", @"ns_ap_res", @"c12"];
    }
}


- (void)testComScoreMeasurementsOnValidVideos
{
    [KIFUITestActor setDefaultTimeout:60];

    for (NSInteger i = 0; i <= 21; i++) {
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        NSString *indexPathKey = [NSString stringWithFormat:@"indexPath-row-%@-section-1", @(i)];
        
        NSString *refLabelsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RTSVideosAnalyticsLabels" ofType:@"plist"];
        NSDictionary *refLabelsDict = [NSDictionary dictionaryWithContentsOfFile:refLabelsPath];

        [tester tapRowAtIndexPath:indexPath inTableViewWithAccessibilityIdentifier:@"tableView"];
        
        NSNotification *notification = [system waitForNotificationName:@"RTSAnalyticsComScoreRequestDidFinish" object:nil];
        NSDictionary *labels = notification.userInfo[@"RTSAnalyticsLabels"];

        if (refLabelsDict[indexPathKey]) {
            
            NSDictionary *refLabels = refLabelsDict[indexPathKey];
            [refLabels enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
                if ([dynamicValueKeys containsObject:key]) {
                    XCTAssertNotNil(labels[key], @"Missing value for key '%@'.", key);
                }
                else {
                    XCTAssertEqualObjects(labels[key], value, @"Wrong value: --%@-- Expected: --%@-- for key '%@'.", labels[key], value, key);
                }
            }];
            
        }
        else {
            // Prepare the content to be inserted inside the .plist.
            NSMutableString *s = [[NSMutableString alloc] init];
            [s appendFormat:@"\t<key>%@</key>\n\t<dict>\n", indexPathKey];
            
            NSArray *sortedKeys = [[labels allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            for (NSString *key in sortedKeys) {
                [s appendFormat:@"\t\t<key>%@</key>\n", key];
                [s appendFormat:@"\t\t<string>%@</string>\n", labels[key]];
            }
            
            [s appendString:@"\t</dict>"];
            NSLog(@"\n\n\n%@\n\n\n", s);
        }
        
        [tester tapViewWithAccessibilityLabel:@"Done"];
    }
}

@end
