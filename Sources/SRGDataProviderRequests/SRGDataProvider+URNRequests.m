//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+URNRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@import libextobjc;

@implementation SRGDataProvider (URNRequests)

+ (NSURLRequest *)URLRequestForURNsPageWithSize:(NSUInteger)size number:(NSUInteger)number URLRequest:(NSURLRequest *)URLRequest
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URLRequest.URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryItems = URLComponents.queryItems.mutableCopy ?: [NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(NSURLQueryItem.new, name), @"urns"];
    NSURLQueryItem *URNsQueryItem = [URLComponents.queryItems filteredArrayUsingPredicate:predicate].firstObject;
    
    if (! URNsQueryItem.value) {
        return nil;
    }
    
    static NSString * const kURNsSeparator = @",";
    NSArray<NSString *> *URNs = [URNsQueryItem.value componentsSeparatedByString:kURNsSeparator];
    if (number == 0 && URNs.count < 2) {
        return URLRequest;
    }
    
    NSUInteger location = number * size;
    if (location >= URNs.count) {
        return nil;
    }
    
    NSRange range = NSMakeRange(location, MIN(size, URNs.count - location));
    NSArray<NSString *> *pageURNs = [URNs subarrayWithRange:range];
    NSURLQueryItem *pageURNsQueryItem = [NSURLQueryItem queryItemWithName:@"urns" value:[pageURNs componentsJoinedByString:kURNsSeparator]];
    [queryItems replaceObjectAtIndex:[queryItems indexOfObject:URNsQueryItem] withObject:pageURNsQueryItem];
    
    URLComponents.queryItems = queryItems.copy;
    
    NSMutableURLRequest *URNsURLRequest = URLRequest.mutableCopy;
    URNsURLRequest.URL = URLComponents.URL;
    return URNsURLRequest.copy;              // Not an immutable copy ;(
}

- (NSURLRequest *)requestMediaWithURN:(NSString *)mediaURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/media/byUrn/%@", mediaURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestMediasWithURNs:(NSArray<NSString *> *)mediaURNs
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/byUrns"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[mediaURNs componentsJoinedByString: @","]] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestLatestMediasForTopicWithURN:(NSString *)topicURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latest/byTopicUrn/%@", topicURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestMostPopularMediasForTopicWithURN:(NSString *)topicURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/mostClicked/byTopicUrn/%@", topicURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestMediaCompositionForURN:(NSString *)mediaURN
                                     standalone:(BOOL)standalone
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.1/mediaComposition/byUrn/%@", mediaURN];
    NSArray<NSURLQueryItem *> *queryItems = standalone ? @[ [NSURLQueryItem queryItemWithName:@"onlyChapters" value:@"true"] ] : nil;
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestShowWithURN:(NSString *)showURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/show/byUrn/%@", showURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

- (NSURLRequest *)requestShowsWithURNs:(NSArray<NSString *> *)showURNs
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showList/byUrns"];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"urns" value:[showURNs componentsJoinedByString: @","]] ];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems];
}

- (NSURLRequest *)requestLatestEpisodesForShowWithURN:(NSString *)showURN
                                maximumPublicationDay:(SRGDay *)maximumPublicationDay
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/episodeComposition/latestByShow/byUrn/%@", showURN];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (maximumPublicationDay) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxPublishedDate" value:maximumPublicationDay.string]];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:queryItems.copy];
}

- (NSURLRequest *)requestLatestMediasForModuleWithURN:(NSString *)moduleURN
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaList/latestByModuleConfigUrn/%@", moduleURN];
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
