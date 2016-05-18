//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <SGVReachability/SGVReachability.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <libextobjc/EXTScope.h>

#import "SRGILDataProvider.h"
#import "SRGILDataProviderConstants.h"
#import "SRGILURLComponents.h"

#import "SRGILOngoingRequest+Private.h"
#import "SRGILRequestsManager.h"

#import "SRGILModel.h"
#import "SRGILList.h"

#import "NSBundle+SRGILDataProvider.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

@interface SRGILRequestsManager () <NSURLSessionDelegate>
@property (nonatomic, copy) NSString *businessUnit;
@property (nonatomic, strong) NSURLSession *URLSession;
@property (nonatomic, strong) NSMutableDictionary *ongoingRequests;
@end

@implementation SRGILRequestsManager

@synthesize baseURL = _baseURL;

static SGVReachability *reachability;

+ (void)initialize
{
    if (self != [SRGILRequestsManager class]) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [SGVReachability mainQueueReachability];
    });
}

- (id)initWithBusinessUnit:(NSString *)businessUnit
{
    NSAssert(businessUnit != nil, @"Expecting 3-letters business identifier string for request manager");
    self = [super init];
    if (self) {
        self.businessUnit = businessUnit;
        self.baseURL = nil;     // Set default base URL
        self.ongoingRequests = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Requesting Media

- (id)requestMediaWithURN:(SRGILURN *)URN completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(URN);
    
    NSString *path = nil;
    Class objectClass = NULL;
    NSString *JSONKey = nil;
    
    switch (URN.mediaType) {
        case SRGILMediaTypeVideo:
            path = [NSString stringWithFormat:@"video/play/%@.json", URN.identifier];
            objectClass = [SRGILVideo class];
            JSONKey = @"Video";
            break;
        case SRGILMediaTypeAudio:
            path = [NSString stringWithFormat:@"audio/play/%@.json", URN.identifier];
            objectClass = [SRGILAudio class];
            JSONKey = @"Audio";
            break;
        case SRGILMediaTypeVideoSet:
            path = [NSString stringWithFormat:@"video/playByAssetSetId/%@.json", URN.identifier];
            objectClass = [SRGILVideo class];
            JSONKey = @"Video";
            break;
            
        default: {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidRequest
                                             userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The request is invalid.", nil) }];
            completionBlock(nil, error);
            return nil;
            break;
        }
    }
    
    return [self requestModelObject:objectClass
                               path:path
                         identifier:URN.identifier
                     serviceVersion:@"1.0"
                            JSONKey:JSONKey
                    completionBlock:completionBlock];
}

- (NSURL *)baseURL
{
    return _baseURL;
}

- (void)setBaseURL:(NSURL *)baseURL
{
    _baseURL = baseURL ?: [NSURL URLWithString:@"http://il.srgssr.ch/integrationlayer/"];
}

- (id)requestLiveMetaInfosWithChannelID:(NSString *)channelID livestreamID:(NSString *)livestreamID completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock;
{
    NSParameterAssert(channelID);
    
    NSString *path = nil;
    if (livestreamID) {
        path = [NSString stringWithFormat:@"channel/%@/nowAndNext.json?livestream=%@", channelID, livestreamID];
    }
    else {
        path = [NSString stringWithFormat:@"channel/%@/nowAndNext.json", channelID];
    }
    
    return [self requestModelObject:[SRGILLiveHeaderChannel class]
                               path:path
                         identifier:path // Trying this
                     serviceVersion:@"1.0"
                            JSONKey:@"Channel"
                    completionBlock:completionBlock];
}

- (id)requestShowWithIdentifier:(NSString *)identifier completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(identifier);
    return [self requestModelObject:SRGILShow.class
                               path:[NSString stringWithFormat:@"assetGroup/detail/%@.json", identifier]
                         identifier:identifier
                     serviceVersion:@"1.0"
                            JSONKey:@"Show"
                    completionBlock:completionBlock];
}

- (id)requestModelObject:(Class)modelClass
                    path:(NSString *)path
              identifier:(NSString *)identifier
          serviceVersion:(NSString *)serviceVersion
                 JSONKey:(NSString *)JSONKey
         completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(modelClass);
    NSParameterAssert(path);
    NSParameterAssert(identifier);
    NSParameterAssert(JSONKey);
    NSParameterAssert(completionBlock);
    NSParameterAssert(serviceVersion);
    
    __block SRGILOngoingRequest *ongoingRequest = self.ongoingRequests[identifier];
    if (ongoingRequest) {
        return [ongoingRequest addCompletionBlock:completionBlock];
    }
    
    @weakify(self)
    void (^completion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        @strongify(self)
        
        [self.ongoingRequests removeObjectForKey:identifier];
        if (self.ongoingRequests.count == 0) {
            [self.URLSession invalidateAndCancel];
            self.URLSession = nil;
        }
        
        void (^callCompletionBlocks)(id, NSError *) = ^(id object, NSError *error) {
            for (SRGILFetchObjectCompletionBlock completionBlock in ongoingRequest.completionBlocks) {
                completionBlock(object, error);
            }
        };
        
        // Request errors
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callCompletionBlocks(nil, error);
            });
            return;
        }
        
        // Parsing errors
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (!JSON || ![JSON isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                     code:SRGILDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                callCompletionBlocks(nil, error);
            });
            return;
        }
        
        // Model errors
        id modelObject = [[modelClass alloc] initWithDictionary:[JSON valueForKey:JSONKey]];
        if (!modelObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                     code:SRGILDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                callCompletionBlocks(nil, error);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callCompletionBlocks(modelObject, nil);
        });
    };
    
    if (!self.URLSession) {
        self.URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        delegate:self
                                                   delegateQueue:nil];
    }
    
    NSURL *completeURL = [[[[self.baseURL URLByAppendingPathComponent:serviceVersion] URLByAppendingPathComponent:@"ue"] URLByAppendingPathComponent:self.businessUnit] URLByAppendingPathComponent:path];
    NSURLSessionTask *task = [self.URLSession dataTaskWithURL:completeURL completionHandler:completion];
    
    DDLogDebug(@"Requesting complete URL %@ for identifier %@", completeURL, identifier);
    
    ongoingRequest = [[SRGILOngoingRequest alloc] initWithTask:task];
    NSString *key = [ongoingRequest addCompletionBlock:completionBlock];
    
    self.ongoingRequests[identifier] = ongoingRequest;
    [task resume];
    
    return key;
}

#pragma mark - Requesting Item Lists

- (id)requestObjectsListWithURLComponents:(SRGILURLComponents *)components
                            progressBlock:(SRGILFetchListDownloadProgressBlock)progressBlock
                          completionBlock:(SRGILRequestListCompletionBlock)completionBlock
{
    NSParameterAssert(components);
    NSParameterAssert(completionBlock);
    
    components.host = self.baseURL.host;
    components.scheme = self.baseURL.scheme;
    NSString *path = components.path;
    if ([path containsString:@"/ue/"]) {
        // We already have a contructed path, so remove it to rebuild it with current components properties (self.baseURL, serviceVersion, businessUnit)
        // It arrives with a reused components object, like for a pull to refresh action.
        // It works with only one /eu/ path component
        NSArray *pathComponents = components.path.pathComponents;
        NSUInteger euIndex = [pathComponents indexOfObject:@"ue"];
        if (pathComponents.count > euIndex + 2) {
            pathComponents = [pathComponents subarrayWithRange:NSMakeRange(euIndex + 2, pathComponents.count - euIndex - 2)];
        }
        else {
            pathComponents = @[];
        }
        path = [NSString pathWithComponents:pathComponents];
    }
    components.path = [NSString pathWithComponents:@[self.baseURL.path,
                                                     components.serviceVersion,
                                                     @"ue",
                                                     self.businessUnit,
                                                     path]];
    
    __block SRGILOngoingRequest *ongoingRequest = self.ongoingRequests[components.URL];
    if (ongoingRequest) {
        return [ongoingRequest addCompletionBlock:completionBlock];
    }
    
    @weakify(self)
    void (^completion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        @strongify(self)
        
        BOOL hasBeenCancelled = (![self.ongoingRequests objectForKey:components.URL]);
        
        [self.ongoingRequests removeObjectForKey:components.URL];
        if (self.ongoingRequests.count == 0) {
            [self.URLSession invalidateAndCancel];
            self.URLSession = nil;
        }
        
        void (^callCompletionBlocks)(id, NSError *) = ^(id object, NSError *error) {
            for (SRGILRequestListCompletionBlock completionBlock in ongoingRequest.completionBlocks) {
                completionBlock(object, error);
            }
        };
        
        if (!hasBeenCancelled) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callCompletionBlocks(nil, error);
                });
                return;
            }
            
            // JSON 1.0 or 2.0
            id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (!JSONObject || ![JSONObject isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                         code:SRGILDataProviderErrorCodeInvalidData
                                                     userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid.", nil) }];
                    callCompletionBlocks(nil, error);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callCompletionBlocks(JSONObject, nil);
            });
        }
    };
    
    if (!self.URLSession) {
        self.URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        delegate:self
                                                   delegateQueue:nil];
    }
    
    NSURLSessionTask *task = [self.URLSession dataTaskWithURL:components.URL completionHandler:completion];
    
    ongoingRequest = [[SRGILOngoingRequest alloc] initWithTask:task];
    NSString *key = [ongoingRequest addCompletionBlock:completionBlock];
    ongoingRequest.progressBlock = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (progressBlock) {
            NSNumber *sumFractions = [[self.ongoingRequests allValues] valueForKeyPath:@"@sum.self"];
            progressBlock([sumFractions floatValue]/[self.ongoingRequests count]);
        }
    };
    
    self.ongoingRequests[components.URL] = ongoingRequest;
    [task resume];
    
    return key;
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSURL *URL = dataTask.originalRequest.URL;
    SRGILOngoingRequest *ongoingRequest = self.ongoingRequests[URL];
    
    if (ongoingRequest.progressBlock) {
        NSUInteger bytesRead = data.length;
        int64_t totalBytesRead = dataTask.countOfBytesReceived;
        int64_t totalBytesExpectedToRead = dataTask.countOfBytesExpectedToReceive;
        ongoingRequest.progressBlock(bytesRead, (long long)totalBytesRead, (long long)totalBytesExpectedToRead);
    }
}

#pragma mark - View Count

- (void)sendViewCountUpdate:(NSString *)identifier forMediaTypeName:(NSString *)mediaType
{
    NSParameterAssert(identifier);
    NSParameterAssert(mediaType);
    
    // Mimicking AFNetworking JSON POST request
    
    NSDictionary *parameters = nil;
    NSString *path = [NSString stringWithFormat:@"%@/%@/clicked.json", mediaType, identifier];
    NSURL *URL = [[[[self.baseURL URLByAppendingPathComponent:@"1.0"] URLByAppendingPathComponent:@"ue"] URLByAppendingPathComponent:self.businessUnit] URLByAppendingPathComponent:path];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSError *error = nil;
    
    [URLRequest setHTTPMethod:@"POST"];
    [URLRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (parameters) {
        [URLRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:(NSJSONWritingOptions)0 error:&error]];
    }
    
    NSURLSession *tmpSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *postDataTask = [tmpSession dataTaskWithRequest:URLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            DDLogError(@"View count failed for asset ID:%@ with error: %@", identifier, [error localizedDescription]);
        }
        else {
            DDLogDebug(@"View count update success for asset ID: %@", identifier);
        }
    }];
    
    [postDataTask resume];
}

#pragma mark - Operations

- (void)cancelRequest:(id)request
{
    if (!request) {
        return;
    }
    
    NSAssert([request isKindOfClass:[NSString class]], @"Expect a string key");
    for (NSString *identifier in self.ongoingRequests.allKeys) {
        SRGILOngoingRequest *ongoingRequest = self.ongoingRequests[identifier];
        
        if ([ongoingRequest.keys containsObject:request]) {
            [ongoingRequest removeCompletionBlockWithKey:request];
        }
        
        if (ongoingRequest.empty) {
            [self.ongoingRequests removeObjectForKey:identifier];
        }
        
        return;
    }
}

#pragma mark - Utilities

+ (BOOL)isUsingWIFI
{
    return [reachability isReachableViaWiFi];
}

+ (BOOL)isOnline
{
    return [reachability isReachable];
}

+ (NSString *)WIFISSID
{
    if ([SRGILRequestsManager isUsingWIFI]) {
        NSArray *interfaces = (__bridge_transfer id)CNCopySupportedInterfaces();
        if ([interfaces count] == 1 && [[interfaces lastObject] isEqualToString:@"en0"]) {
            NSString *interface = [interfaces lastObject];
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interface);
            id ssid = info[@"SSID"] ?: info[@"ssid"];
            if ([ssid isKindOfClass:[NSString class]]) {
                return (NSString *)ssid;
            }
        }
    }
    return nil;
}

+ (BOOL)isUsingSwisscomWIFI
{
    NSString *ssid = [SRGILRequestsManager WIFISSID];
    if (ssid) {
        // See http://www.swisscom.ch/en/residential/internet/internet-on-the-move/pwlan.html
        NSSet *swisscomSSIDs = [NSSet setWithArray:@[@"MOBILE", @"MOBILE-EAPSIM", @"Swisscom", @"Swisscom_Auto_Login"]];
        return [swisscomSSIDs containsObject:ssid];
    }
    return NO;
}
@end