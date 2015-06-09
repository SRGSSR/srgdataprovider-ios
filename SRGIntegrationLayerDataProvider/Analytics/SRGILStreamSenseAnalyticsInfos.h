//
//  SRGStreamSenseAnalyticsDataSource.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 10/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILAnalyticsInfosProtocol.h"
#import "SRGILMedia.h"

@interface SRGILStreamSenseAnalyticsInfos : NSObject <SRGILAnalyticsInfos>

- (NSDictionary *)playlistMetadataForBusinesUnit:(NSString *)businessUnit;
- (NSDictionary *)fullLengthClipMetadata;
- (NSDictionary *)segmentClipMetadataForMedia:(SRGILMedia *)mediaFullLengthOrSegment;

@end
