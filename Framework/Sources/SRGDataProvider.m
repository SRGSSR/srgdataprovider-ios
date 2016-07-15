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

- (NSURLSessionTask *)trendingMediasWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self trendingMediasWithEditorialLimit:nil completionBlock:completionBlock];
}

- (NSURLSessionTask *)trendingMediasWithEditorialLimit:(nullable NSNumber *)editorialLimit completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/trending.json", self.businessUnitIdentifier];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue] ];
    }
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGMedia class] queryItems:queryItems rootKey:@"mediaList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)topicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv.json", self.businessUnitIdentifier];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGTopic class] queryItems:nil rootKey:@"topicList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)latestMediasForTopicWithUid:(NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid];
    return [self listObjectsForResourcePath:resourcePath withModelClass:[SRGMedia class] queryItems:nil rootKey:@"mediaList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)compositionForMediaWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    return nil;
}

#pragma mark Request common implementation

- (NSURLSessionTask *)listObjectsForResourcePath:(NSString *)resourcePath withModelClass:(Class)modelClass queryItems:(NSArray<NSURLQueryItem *> *)queryItems rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(resourcePath);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    NSURL *URL = [NSURL URLWithString:resourcePath relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    URLComponents.queryItems = queryItems;
    
    return [self.session dataTaskWithURL:URLComponents.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            return;
        }
        
        // Expect a root dictionary with an array of objects stored for the specified root key
        id JSONRootObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (JSONRootObject && [JSONRootObject isKindOfClass:[NSDictionary class]]) {
            id JSONObjects = [JSONRootObject objectForKey:rootKey];
            if (JSONObjects && [JSONObjects isKindOfClass:[NSArray class]]) {
                NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONObjects error:NULL];
                if (objects) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(objects, nil);
                    });
                    return;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
        });
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
