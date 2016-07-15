//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

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

// TODO: Improve: Service URL must be a proper base URL, ending with a slash if needed
// See http://stackoverflow.com/questions/16582350/nsurl-urlwithstringrelativetourl-is-clipping-relative-url

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    if (self = [super init]) {
        self.serviceURL = serviceURL;
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

- (NSURLSessionTask *)listTopicsWithCompletionBlock:(void (^)(NSArray<SRGTopic *> * _Nullable, NSError * _Nullable))completionBlock
{
    NSURL *URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"2.0/%@/topicList/tv.json", self.businessUnitIdentifier] relativeToURL:self.serviceURL];
    return [self listObjectsForURL:URL withModelClass:[SRGTopic class] rootKey:@"topicList" completionBlock:completionBlock];
}

- (NSURLSessionTask *)listMediasForTopicWithUid:(NSString *)topicUid completionBlock:(void (^)(NSArray<SRGMedia *> * _Nullable, NSError * _Nullable))completionBlock
{
    NSURL *URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid] relativeToURL:self.serviceURL];
    return [self listObjectsForURL:URL withModelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

#pragma mark Request common implementation

- (NSURLSessionTask *)listObjectsForURL:(NSURL *)URL withModelClass:(Class)modelClass rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(URL);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [self.session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
        
        // TODO: Return user-friendly data inconsistency error
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, [NSError errorWithDomain:@"domain" code:1012 userInfo:nil]);
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
