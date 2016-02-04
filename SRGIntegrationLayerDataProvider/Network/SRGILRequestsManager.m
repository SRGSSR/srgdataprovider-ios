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
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURLSession *URLSession;
@property (nonatomic, strong) NSMutableDictionary *ongoingRequests;
@property (nonatomic, strong) NSMutableDictionary *ongoingVideoListDownloads;
@end

@implementation SRGILRequestsManager

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
        self.baseURL = [[NSURL URLWithString:@"http://il.srgssr.ch/integrationlayer/1.0/ue/"] URLByAppendingPathComponent:businessUnit];
        self.ongoingRequests = [NSMutableDictionary dictionary];
        self.ongoingVideoListDownloads = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)businessUnit
{
    return [self.baseURL lastPathComponent];
}

#pragma mark - Requesting Media

- (BOOL)requestMediaWithURN:(SRGILURN *)URN completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
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

        default: {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidRequest
                                             userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The request is invalid", nil) }];
            completionBlock(nil, error);
            return NO;
            break;
        }
    }

    return [self requestModelObject:objectClass
                               path:path
                         identifier:URN.identifier
                            JSONKey:JSONKey
                    completionBlock:completionBlock];
}

- (BOOL)requestLiveMetaInfosWithChannelID:(NSString *)channelID completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock;
{
    NSParameterAssert(channelID);
    NSString *path = [NSString stringWithFormat:@"channel/%@/nowAndNext.json", channelID];
    return [self requestModelObject:[SRGILLiveHeaderChannel class]
                               path:path
                         identifier:path // Trying this
                            JSONKey:@"Channel"
                    completionBlock:completionBlock];
}

- (BOOL)requestShowWithIdentifier:(NSString *)identifier completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
{
    NSParameterAssert(identifier);
    return [self requestModelObject:SRGILShow.class
                               path:[NSString stringWithFormat:@"assetGroup/detail/%@.json", identifier]
                         identifier:identifier
                            JSONKey:@"Show"
                    completionBlock:completionBlock];
}

- (BOOL)requestModelObject:(Class)modelClass
                      path:(NSString *)path
                identifier:(NSString *)identifier
                   JSONKey:(NSString *)JSONKey
           completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock
{
    NSAssert(modelClass, @"Missing model class");
    NSAssert(path, @"Missing model request URL path");
    NSAssert(identifier, @"Missing media ID");
    NSAssert(JSONKey, @"Missing JSON key");
    NSAssert(completionBlock, @"Missing completion block");

    __block SRGILOngoingRequest *ongoingRequest = self.ongoingRequests[identifier];
    if (ongoingRequest) {
        [ongoingRequest addCompletionBlock:completionBlock];
        return YES;
    }
    
    @weakify(self)
    void (^completion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        @strongify(self)

        [self.ongoingRequests removeObjectForKey:identifier];
        if (self.ongoingRequests.count == 0) {
            [self.URLSession invalidateAndCancel];
            self.URLSession = nil;
        }
        
        void (^callCompletionBlocks)(SRGILMedia *, NSError *) = ^(SRGILMedia *media, NSError *error) {
            for (SRGILFetchObjectCompletionBlock completionBlock in ongoingRequest.completionBlocks) {
                completionBlock(media, error);
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
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid", nil) }];
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
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid", nil) }];
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
    
    NSURL *completeURL = [self.baseURL URLByAppendingPathComponent:path];
    NSURLSessionTask *task = [self.URLSession dataTaskWithURL:completeURL completionHandler:completion];
    
    DDLogDebug(@"Requesting complete URL %@ for identifier %@", completeURL, identifier);
    
    ongoingRequest = [[SRGILOngoingRequest alloc] initWithTask:task];
    [ongoingRequest addCompletionBlock:completionBlock];

    self.ongoingRequests[identifier] = ongoingRequest;
    [task resume];
    
    return YES;
}

#pragma mark - Requesting Item Lists

- (BOOL)requestObjectsListWithURLComponents:(SRGILURLComponents *)components
                              progressBlock:(SRGILFetchListDownloadProgressBlock)progressBlock
                            completionBlock:(SRGILRequestListCompletionBlock)completionBlock
{
    NSAssert(components, @"An SRGILURNComponents instance is required, otherwise, what's the point?");
    NSAssert(completionBlock, @"A completion block is required, otherwise, what's the point?");
    
    components.host = self.baseURL.host;
    components.scheme = self.baseURL.scheme;
    if (NO == [components.path hasPrefix:self.baseURL.path]) {
        components.path = [self.baseURL.path stringByAppendingString:components.path];
    }
    
        // Fill dictionary with 0 numbers, as we need the count of requests for the total fraction
    NSNumber *downloadFraction = [self.ongoingVideoListDownloads objectForKey:components.string];
    if (!downloadFraction) {
        [self.ongoingVideoListDownloads setObject:@(0.0) forKey:components.string];
    }
    
    @weakify(self)
    void (^completion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        @strongify(self)
        
        BOOL hasBeenCancelled = (![self.ongoingRequests objectForKey:components.URL]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ongoingRequests removeObjectForKey:components.URL];
            if (self.ongoingRequests.count == 0) {
                [self.ongoingVideoListDownloads removeAllObjects];
                [self.URLSession invalidateAndCancel];
                self.URLSession = nil;
            }
        });
        
        if (!hasBeenCancelled) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
                return;
            }
            
            id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (!JSONObject || ![JSONObject isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                         code:SRGILDataProviderErrorCodeInvalidData
                                                     userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The data is invalid", nil) }];
                    completionBlock(nil, error);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(JSONObject, nil);
            });
        }
    };
    
    if (!self.URLSession) {
        self.URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        delegate:self
                                                   delegateQueue:nil];
    }

    NSURLSessionTask *task = [self.URLSession dataTaskWithURL:components.URL completionHandler:completion];
    
    SRGILOngoingRequest *ongoingRequest = [[SRGILOngoingRequest alloc] initWithTask:task];
    ongoingRequest.progressBlock = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (totalBytesExpectedToRead >= 0) { // Will be -1 when unknown
            float fraction = (float)bytesRead/(float)totalBytesRead;
            [self.ongoingVideoListDownloads setObject:@(fraction) forKey:components.URL];
        }
        
        if (progressBlock) {
            NSNumber *sumFractions = [[self.ongoingVideoListDownloads allValues] valueForKeyPath:@"@sum.self"];
            progressBlock([sumFractions floatValue]/[self.ongoingVideoListDownloads count]);
        }
    };
    
    self.ongoingRequests[components.URL] = ongoingRequest;
    [task resume];
    
    return YES;
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
    
    // Mimicking AFNetworking JSON POST request

    NSDictionary *parameters = nil;
    NSString *path = [NSString stringWithFormat:@"%@/%@/clicked.json", mediaType, identifier];
    NSURL *URL = [self.baseURL URLByAppendingPathComponent:path];
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

- (void)cancelAllRequests
{
    if ([self.ongoingRequests count] == 0) {
        return;
    }
    
    DDLogInfo(@"Cancelling all (%lu) requests.", (unsigned long)[self.ongoingRequests count]);
    
    [self.URLSession invalidateAndCancel];
    [self.ongoingRequests removeAllObjects];
    [self.ongoingVideoListDownloads removeAllObjects];
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