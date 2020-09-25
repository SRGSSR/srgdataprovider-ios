//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+GeneralRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (GeneralRequests)

- (NSURLRequest *)requestServiceMessageForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/general/information", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
