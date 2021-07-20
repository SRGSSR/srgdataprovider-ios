//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+ContentRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (ContentRequests)

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                          uid:(NSString *)uid
                                    published:(BOOL)published
                                       atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/page/%@", SRGPathComponentForVendor(vendor), uid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                    mediaType:(SRGMediaType)mediaType
                                    published:(BOOL)published
                                       atDate:(NSDate *)date
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_mediaTypes;
    dispatch_once(&s_onceToken, ^{
        s_mediaTypes = @{ @(SRGMediaTypeVideo) : @"video",
                          @(SRGMediaTypeAudio) : @"audio" };
    });
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/page/byLandingPage/%@", SRGPathComponentForVendor(vendor), s_mediaTypes[@(mediaType)]];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestContentPageForVendor:(SRGVendor)vendor
                                 topicWithURN:(NSString *)topicURN
                                    published:(BOOL)published
                                       atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/page/byTopicUrn/%@", SRGPathComponentForVendor(vendor), topicURN];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestContentSectionForVendor:(SRGVendor)vendor
                                             uid:(NSString *)uid
                                       published:(BOOL)published
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/section/%@", SRGPathComponentForVendor(vendor), uid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                       contentSectionUid:(NSString *)contentSectionUid
                                  userId:(NSString *)userId
                               published:(BOOL)published
                                  atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/section/mediaSection/%@", SRGPathComponentForVendor(vendor), contentSectionUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (userId) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"userId" value:userId]];
    }
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                      contentSectionUid:(NSString *)contentSectionUid
                                 userId:(NSString *)userId
                              published:(BOOL)published
                                 atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/section/showSection/%@", SRGPathComponentForVendor(vendor), contentSectionUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (userId) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"userId" value:userId]];
    }
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestShowAndMediasForVendor:(SRGVendor)vendor
                              contentSectionUid:(NSString *)contentSectionUid
                                         userId:(NSString *)userId
                                      published:(BOOL)published
                                         atDate:(NSDate *)date
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/section/mediaSectionWithShow/%@", SRGPathComponentForVendor(vendor), contentSectionUid];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (userId) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"userId" value:userId]];
    }
    if (! published) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"published" value:@"false"]];
    }
    if (date) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"previewDate" value:SRGStringFromDate(date)]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end
