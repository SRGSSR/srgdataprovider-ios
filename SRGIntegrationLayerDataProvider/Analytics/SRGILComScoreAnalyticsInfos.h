//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILAnalyticsInfosProtocol.h"

@interface SRGILComScoreAnalyticsInfos : NSObject <SRGILAnalyticsInfos>

+ (NSDictionary *)globalLabelsForAppEnteringForeground;
- (NSDictionary *)statusLabels;

@end
