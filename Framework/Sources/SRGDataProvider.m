//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import "NSBundle+SRGIntegrationLayerDataProvider.h"
#import "NSURLSession+SRGIntegrationLayerDataProvider.h"
#import "SRGDataProviderError.h"

#import <Mantle/Mantle.h>

NSString * const SRGBusinessIdentifierRSI = @"rsi";
NSString * const SRGBusinessIdentifierRTR = @"rtr";
NSString * const SRGBusinessIdentifierRTS = @"rts";
NSString * const SRGBusinessIdentifierSRF = @"srf";
NSString * const SRGBusinessIdentifierSWI = @"swi";

static SRGDataProvider *s_currentDataProvider;

@interface SRGDataProvider ()

@property (nonatomic) NSURL *serviceURL;
@property (nonatomic, copy) NSString *businessUnitIdentifier;
@property (nonatomic) NSURLSession *session;

@end

@implementation SRGDataProvider

#pragma mark Class methods

+ (SRGDataProvider *)currentDataProvider
{
    return s_currentDataProvider;
}

+ (SRGDataProvider *)setCurrentDataProvider:(SRGDataProvider *)currentDataProvider
{
    SRGDataProvider *previousDataProvider = s_currentDataProvider;
    s_currentDataProvider = currentDataProvider;
    return previousDataProvider;
}

#pragma mark Object lifecycle

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    if (self = [super init]) {
        // According to the standard, the base URL must end with a slash or the last path component will be truncated
        // See http://stackoverflow.com/questions/16582350/nsurl-urlwithstringrelativetourl-is-clipping-relative-url
        if ([serviceURL.absoluteString hasSuffix:@"/"]) {
            self.serviceURL = serviceURL;
        }
        else {
            self.serviceURL = [NSURL URLWithString:[serviceURL.absoluteString stringByAppendingString:@"/"]];
        }
        
        self.businessUnitIdentifier = businessUnitIdentifier;
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark User requests

- (SRGRequest *)trendingVideosWithPagination:(SRGPagination *)pagination completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self trendingVideosWithEditorialLimit:nil pagination:pagination completionBlock:completionBlock];
}

- (SRGRequest *)trendingVideosWithEditorialLimit:(NSNumber *)editorialLimit pagination:(SRGPagination *)pagination completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/trending.json", self.businessUnitIdentifier];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems pagination:pagination];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)latestVideosWithPagination:(SRGPagination *)pagination completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latest.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:pagination];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL]modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)mostPopularVideosWithPagination:(SRGPagination *)pagination completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/mostClicked.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:pagination];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGTopic class] rootKey:@"topicList" completionBlock:^(NSArray * _Nullable objects, SRGPagination * _Nullable nextPagination, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)latestVideosForTopicWithUid:(NSString *)topicUid pagination:(SRGPagination *)pagination completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:pagination];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/tv/alphabetical.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, SRGPagination * _Nullable nextPagination, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaComposition/video/%@.json", self.businessUnitIdentifier, mediaUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMediaComposition class] completionBlock:completionBlock];
}

- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock
{
    SRGChapter *mainChapter = mediaComposition.mainChapter;
    if (!mediaComposition.event || !mainChapter) {
        NSError *error = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                             code:SRGDataProviderErrorCodeInvalidRequest
                                         userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The request is invalid.", nil) }];
        return [self reportError:error withCompletionBlock:^(NSError * _Nullable error) {
            completionBlock(nil, error);
        }];
    }
    
    NSString *mediaTypeString = (mainChapter.mediaType == SRGMediaTypeAudio) ? @"audio" : @"video";
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaStatistic/%@/%@/liked.json", self.businessUnitIdentifier, mediaTypeString, mainChapter.uid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil pagination:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyJSONDictionary = @{ @"eventData" : mediaComposition.event };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyJSONDictionary options:0 error:NULL];
    
    return [self fetchObjectWithRequest:request modelClass:[SRGLike class] completionBlock:completionBlock];
}

#pragma mark Common implementation. Completion blocks are called on the main thread

- (SRGRequest *)listObjectsWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, SRGPagination * _Nullable nextPagination, NSError * _Nullable error))completionBlock
{
    return [self asynchronouslyListObjectsWithRequest:request modelClass:modelClass rootKey:rootKey completionBlock:^(NSArray * _Nullable objects, SRGPagination * _Nullable nextPagination, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(objects, nextPagination, error);
        });
    }];
}

- (SRGRequest *)fetchObjectWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass completionBlock:(void (^)(id _Nullable object, NSError * _Nullable error))completionBlock
{
    return [self asynchronouslyFetchObjectWithRequest:request modelClass:modelClass completionBlock:^(id  _Nullable object, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(object, error);
        });
    }];
}

- (SRGRequest *)reportError:(NSError *)error withCompletionBlock:(void (^)(NSError * _Nullable error))completionBlock
{
    return [self.session srg_taskForError:error withCompletionHandler:^(NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(error);
        });
    }];
}

#pragma mark Asynchronous requests and processing. The completion block will be called on a background thread

- (NSURL *)URLForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems pagination:(SRGPagination *)pagination
{
    NSURL *URL = [NSURL URLWithString:resourcePath relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    if (pagination) {
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:@(pagination.size).stringValue]];
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"pageNumber" value:@(pagination.page).stringValue]];
    }
    URLComponents.queryItems = fullQueryItems.count != 0 ? [fullQueryItems copy] : nil;
    
    return URLComponents.URL;
}

- (SRGRequest *)asynchronouslyFetchJSONDictionaryWithRequest:(NSURLRequest *)request withCompletionBlock:(void (^)(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(completionBlock);
    
    return [self.session srg_dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        // Properly handle HTTP error codes >= 400 as real errors
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            NSInteger HTTPStatusCode = HTTPURLResponse.statusCode;
            if (HTTPStatusCode >= 400) {
                completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                         code:SRGDataProviderErrorHTTP
                                                     userInfo:@{ NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:HTTPStatusCode],
                                                                 NSURLErrorKey : response.URL }]);
                return;
            }
        }
        
        id JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (!JSONDictionary || ![JSONDictionary isKindOfClass:[NSDictionary class]]) {
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
            return;
        }
        
        completionBlock(JSONDictionary, nil);
    }];
}

- (SRGRequest *)asynchronouslyListObjectsWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, SRGPagination * _Nullable nextPagination, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [self asynchronouslyFetchJSONDictionaryWithRequest:request withCompletionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, nil, error);
            return;
        }
        
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:[NSArray class]]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:NULL];
            if (objects) {
                if ([JSONDictionary[@"hasMoreItems"] boolValue]) {
                    NSInteger size = [JSONDictionary[@"pageSize"] integerValue];
                    NSInteger page = [JSONDictionary[@"pageNumber"] integerValue];
                    completionBlock(objects, [[SRGPagination paginationForPage:page ofSize:size] paginationForNextPage], nil);
                }
                else {
                    completionBlock(objects, nil, nil);
                }
                return;
            }
        }
        
        completionBlock(nil, nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                      code:SRGDataProviderErrorCodeInvalidData
                                                  userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
    }];
}

- (SRGRequest *)asynchronouslyFetchObjectWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass completionBlock:(void (^)(id _Nullable object, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [self asynchronouslyFetchJSONDictionaryWithRequest:request withCompletionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:NULL];
        if (!object) {
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
            return;
        }
        
        completionBlock(object, nil);
    }];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; serviceURL: %@; businessUnitIdentifier: %@>",
            [self class],
            self,
            self.serviceURL,
            self.businessUnitIdentifier];
}

@end
