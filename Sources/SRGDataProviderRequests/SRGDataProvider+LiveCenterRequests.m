//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+LiveCenterRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (LiveCenterRequests)

- (NSURLRequest *)requestLiveCenterVideosForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/scheduledLivestreams/livecenter", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
