//
//  SRGStreamSenseAnalyticsDataSource.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 10/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGAnalyticsIndividualDataSource.h"

@interface SRGILStreamSenseAnalyticsIndividualDataSource : NSObject <SRGAnalyticsIndividualDataSource>

- (NSDictionary *)playlistMetadata;
- (NSDictionary *)fullLengthClipMetadata;
- (NSDictionary *)segmentClipMetadata;

@end
