//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import "NSBundle+SRGIntegrationLayerDataProvider.h"
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

- (NSURLSessionTask *)trendingVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self trendingVideosWithEditorialLimit:nil completionBlock:completionBlock];
}

- (NSURLSessionTask *)trendingVideosWithEditorialLimit:(nullable NSNumber *)editorialLimit completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/trending.json", self.businessUnitIdentifier];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue] ];
    }
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGMedia class] queryItems:queryItems rootKey:@"mediaList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)latestVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latest.json", self.businessUnitIdentifier];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGMedia class] queryItems:nil rootKey:@"mediaList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)mostPopularVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/mostClicked.json", self.businessUnitIdentifier];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGMedia class] queryItems:nil rootKey:@"mediaList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv.json", self.businessUnitIdentifier];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGTopic class] queryItems:nil rootKey:@"topicList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)latestVideosForTopicWithUid:(NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGMedia class] queryItems:nil rootKey:@"mediaList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/tv/alphabetical.json", self.businessUnitIdentifier];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGShow class] queryItems:nil rootKey:@"showList" completionBlock:completionBlock];

}

- (NSURLSessionTask *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaComposition/video/%@.json", self.businessUnitIdentifier, mediaUid];
    return [self objectForResourcePath:resourcePath withModelClass:[SRGMediaComposition class] queryItems:nil completionBlock:completionBlock];
}

- (NSURLSessionTask *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock
{
    SRGChapter *mainChapter = mediaComposition.mainChapter;
    if (!mainChapter) {
        return nil;
    }
    
    NSString *mediaTypeString = (mainChapter.mediaType == SRGMediaTypeAudio) ? @"audio" : @"video";
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaStatistic/%@/%@/liked.json", self.businessUnitIdentifier, mediaTypeString, mainChapter.uid];
    
    return nil;
}

#pragma mark Common implementation. Completion blocks are called on the main thread

- (NSURLSessionTask *)listObjectsForResourcePath:(NSString *)resourcePath withModelClass:(Class)modelClass queryItems:(NSArray<NSURLQueryItem *> *)queryItems rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, NSError * _Nullable error))completionBlock
{
    return [self asynchronouslyListObjectsForResourcePath:resourcePath withModelClass:modelClass queryItems:queryItems rootKey:rootKey completionBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(objects, error);
        });
    }];
}

- (NSURLSessionTask *)objectForResourcePath:(NSString *)resourcePath withModelClass:(Class)modelClass queryItems:(NSArray<NSURLQueryItem *> *)queryItems completionBlock:(void (^)(id _Nullable object, NSError * _Nullable error))completionBlock
{
    return [self asynchronouslyFetchObjectForResourcePath:resourcePath withModelClass:modelClass queryItems:queryItems completionBlock:^(id  _Nullable object, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(object, error);
        });
    }];
}

#pragma mark Asynchronous requests and processing. The completion block will be called on a background thread

- (NSURLSessionTask *)asynchronouslyRequestResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems completionBlock:(void (^)(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(resourcePath);
    NSParameterAssert(completionBlock);
    
    NSURL *URL = [NSURL URLWithString:resourcePath relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    URLComponents.queryItems = queryItems;
    
    return [self.session dataTaskWithURL:URLComponents.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
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

- (NSURLSessionTask *)asynchronouslyListObjectsForResourcePath:(NSString *)resourcePath withModelClass:(Class)modelClass queryItems:(NSArray<NSURLQueryItem *> *)queryItems rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(resourcePath);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [self asynchronouslyRequestResourcePath:resourcePath withQueryItems:queryItems completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:[NSArray class]]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:NULL];
            if (objects) {
                completionBlock(objects, nil);
                return;
            }
            
        }
        
        completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                 code:SRGDataProviderErrorCodeInvalidData
                                             userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
    }];
}

- (NSURLSessionTask *)asynchronouslyFetchObjectForResourcePath:(NSString *)resourcePath withModelClass:(Class)modelClass queryItems:(NSArray<NSURLQueryItem *> *)queryItems completionBlock:(void (^)(id _Nullable object, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(resourcePath);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [self asynchronouslyRequestResourcePath:resourcePath withQueryItems:queryItems completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
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
