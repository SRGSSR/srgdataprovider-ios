//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
        // FIXME: ns_st_cl values are now rounded with Analytics >= 1.4.3. This makes the tests fail because of small
        //        differences with the previously calculated results (rounding probably because of CMTimeGetSeconds).
        //        In the meantime, this field has been marked as dynamic
        dynamicValueKeys = @[@"ns_ap_cs", @"ns_st_bp", @"ns_st_pv", @"ns_ap_id", @"ns_st_po", @"ns_st_br", @"ns_ts",
                             @"ns_st_bt", @"ns_st_id", @"ns_ap_ec", @"ns_st_cu", @"ns_st_mv", @"ns_ap_res", @"ns_ap_ar",
                             @"ns_ap_pv", @"ns_ap_pfv", @"ns_st_cs", @"c12", @"ns_st_cl"];
    }
}

- (void)testComScoreMeasurementsOnValidVideos
{
    [KIFUITestActor setDefaultTimeout:60];

    for (NSInteger i = 0; i < 22; i++) {
    
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
