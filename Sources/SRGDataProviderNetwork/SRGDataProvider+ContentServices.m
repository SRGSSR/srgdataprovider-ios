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
                                 uid:(NSString *)uid
                           published:(BOOL)published
                              atDate:(NSDate *)date
                 withCompletionBlock:(SRGContentPageCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestContentPageForVendor:vendor uid:uid published:published atDate:date];
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

- (SRGRequest *)contentSectionForVendor:(SRGVendor)vendor
                                    uid:(NSString *)uid
                              published:(BOOL)published
                    withCompletionBlock:(SRGContentSectionCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestContentSectionForVendor:vendor uid:uid published:published];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGContentSection.class completionBlock:completionBlock];
}

- (SRGFirstPageRequest *)mediasForVendor:(SRGVendor)vendor
                       contentSectionUid:(NSString *)contentSectionUid
                                  userId:(NSString *)userId
                               published:(BOOL)published
                                  atDate:(NSDate *)date
                     withCompletionBlock:(SRGPaginatedMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestMediasForVendor:vendor contentSectionUid:contentSectionUid userId:userId published:published atDate:date];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGMedia.class rootKey:@"mediaList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> * _Nonnull metadata, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)showsForVendor:(SRGVendor)vendor
                      contentSectionUid:(NSString *)contentSectionUid
                                 userId:(NSString *)userId
                              published:(BOOL)published
                                 atDate:(NSDate *)date
                    withCompletionBlock:(SRGPaginatedShowListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestShowsForVendor:vendor contentSectionUid:contentSectionUid userId:userId published:published atDate:date];
    return [self listPaginatedObjectsWithURLRequest:URLRequest modelClass:SRGShow.class rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, NSDictionary<NSString *,id> * _Nonnull metadata, SRGPage * _Nonnull page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(objects, page, nextPage, HTTPResponse, error);
    }];
}

- (SRGFirstPageRequest *)showAndMediasForVendor:(SRGVendor)vendor
                              contentSectionUid:(NSString *)contentSectionUid
                                         userId:(NSString *)userId
                                      published:(BOOL)published
                                         atDate:(NSDate *)date
                            withCompletionBlock:(SRGPaginatedShowAndMediaListCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestShowAndMediasForVendor:vendor contentSectionUid:contentSectionUid userId:userId published:published atDate:date];
    return [self pageRequestWithURLRequest:URLRequest parser:^id(NSDictionary *JSONDictionary, NSError *__autoreleasing *pError) {
        return [MTLJSONAdapter modelOfClass:SRGShowAndMedias.class fromJSONDictionary:JSONDictionary error:pError];
    } completionBlock:^(id _Nullable object, NSDictionary<NSString *,id> *metadata, SRGPage *page, SRGPage * _Nullable nextPage, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        completionBlock(object, page, nextPage, HTTPResponse, error);
    }];
}

@end
