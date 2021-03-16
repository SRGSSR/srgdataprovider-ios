//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ContentServices.h"

#import "SRGDataProvider+Network.h"

@import SRGDataProviderRequests;

@implementation SRGDataProvider (ContentServices)

- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                             pageUid:(NSString *)pageUid
                           published:(BOOL)published
                              atDate:(NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestContentPageForVendor:vendor pageUid:pageUid published:published atDate:date];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGContentPage.class completionBlock:completionBlock];
}

- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                           mediaType:(SRGMediaType)mediaType
                           published:(BOOL)published
                              atDate:(NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestContentPageForVendor:vendor mediaType:mediaType published:published atDate:date];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGContentPage.class completionBlock:completionBlock];
}

- (SRGRequest *)contentPageForVendor:(SRGVendor)vendor
                        topicWithURN:(NSString *)topicURN
                           published:(BOOL)published
                              atDate:(NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestContentPageForVendor:vendor topicWithURN:topicURN published:published atDate:date];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGContentPage.class completionBlock:completionBlock];
}

@end
