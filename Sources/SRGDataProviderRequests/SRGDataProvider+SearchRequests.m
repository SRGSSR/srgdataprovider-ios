//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+SearchRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (SearchRequests)

- (NSURLRequest *)requestMediasForVendor:(SRGVendor)vendor
                           matchingQuery:(NSString *)query
                            withSettings:(SRGMediaSearchSettings *)settings
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultMediaList", SRGPathComponentForVendor(vendor)];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (query) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"q" value:query]];
    }
    
    if (settings) {
        [queryItems addObjectsFromArray:settings.queryItems];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestShowsForVendor:(SRGVendor)vendor
                          matchingQuery:(NSString *)query
                              mediaType:(SRGMediaType)mediaType
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/searchResultShowList", SRGPathComponentForVendor(vendor)];
    
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_mediaTypes;
    dispatch_once(&s_onceToken, ^{
        s_mediaTypes = @{ @(SRGMediaTypeVideo) : @"video",
                          @(SRGMediaTypeAudio) : @"audio" };
    });
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray arrayWithObject:[NSURLQueryItem queryItemWithName:@"q" value:query]];
    NSString *mediaTypeParameter = s_mediaTypes[@(mediaType)];
    if (mediaTypeParameter) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"mediaType" value:mediaTypeParameter]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestMostSearchedShowsForVendor:(SRGVendor)vendor
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/mostClickedSearchResults", SRGPathComponentForVendor(vendor)];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestVideosForVendor:(SRGVendor)vendor
                                withTags:(NSArray<NSString *> *)tags
                            excludedTags:(NSArray<NSString *> *)excludedTags
                      fullLengthExcluded:(BOOL)fullLengthExcluded
{
    NSString *resourcePath = nil;
    if (fullLengthExcluded) {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTags/excludeFullLength", SRGPathComponentForVendor(vendor)];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTags", SRGPathComponentForVendor(vendor)];
    }
    
    NSString *includesString = [tags componentsJoinedByString:@","];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"includes" value:includesString] ];
    if (excludedTags) {
        NSString *excludesString = [tags componentsJoinedByString:@","];
        queryItems = [queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"excludes" value:excludesString]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

@end
