//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ModuleRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (ModuleRequests)

- (NSURLRequest *)requestModulesForVendor:(SRGVendor)vendor
                                     type:(SRGModuleType)moduleType
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/moduleConfigList/%@", SRGPathComponentForVendor(vendor), SRGPathComponentForModuleType(moduleType)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
