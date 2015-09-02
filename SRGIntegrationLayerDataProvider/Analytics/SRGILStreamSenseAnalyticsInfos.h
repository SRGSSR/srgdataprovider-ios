//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILAnalyticsInfosProtocol.h"
#import "SRGILMedia.h"

@interface SRGILStreamSenseAnalyticsInfos : NSObject <SRGILAnalyticsInfos>

- (NSDictionary *)playlistMetadataForBusinesUnit:(NSString *)businessUnit;
- (NSDictionary *)fullLengthClipMetadata;
- (NSDictionary *)segmentClipMetadataForMedia:(SRGILMedia *)mediaFullLengthOrSegment;

@end
