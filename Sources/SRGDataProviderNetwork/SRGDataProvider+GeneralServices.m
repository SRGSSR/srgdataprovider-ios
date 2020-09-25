//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+GeneralServices.h"

#import "SRGDataProvider+Network.h"

@import SRGDataProviderRequests;

@implementation SRGDataProvider (GeneralServices)

- (SRGRequest *)serviceMessageForVendor:(SRGVendor)vendor withCompletionBlock:(SRGServiceMessageCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestServiceMessageForVendor:vendor];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGServiceMessage.class completionBlock:completionBlock];
}

@end
