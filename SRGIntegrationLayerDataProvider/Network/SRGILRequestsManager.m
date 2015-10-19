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

#import "SRGILOngoingRequest+Private.h"
#import "SRGILRequestsManager.h"
#import "SRGILOrganisedModelDataItem.h"

#import "SRGILModel.h"
#import "SRGILErrors.h"
#import "SRGILList.h"

#import "NSBundle+SRGILDataProvider.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

@interface NSError (SRGNetwork)
- (BOOL)isNetworkError;
@end

@implementation NSError (SRGNetwork)

- (BOOL)isNetworkError
{
    NSArray *connectionErrorList = @[
                                     @(NSURLErrorUnknown),
                                     @(NSURLErrorCancelled),
                                     @(NSURLErrorTimedOut),
                                     @(NSURLErrorCannotFindHost),
                                     @(NSURLErrorNetworkConnectionLost),
                                     @(NSURLErrorDNSLookupFailed),
                                     @(NSURLErrorNotConnectedToInternet),
                                     @(NSURLErrorCannotLoadFromNetwork),
                                     @(NSURLErrorInternationalRoamingOff),
                                     @(NSURLErrorCallIsActive),
                                     @(NSURLErrorDataNotAllowed),
                                     ];
    
    return [self.domain isEqualToString:NSURLErrorDomain] && [connectionErrorList containsObject:@(self.code)];
}

@end

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

- (BOOL)requestMediaOfType:(enum SRGILMediaType)mediaType
            withIdentifier:(NSString *)identifier
           completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock
{    
    NSString *path = nil;
    Class objectClass = NULL;
    NSString *JSONKey = nil;
    NSString *errorMessage = nil;

    switch (mediaType) {
        case SRGILMediaTypeVideo:
            path = [NSString stringWithFormat:@"video/play/%@.json", identifier];
            objectClass = [SRGILVideo class];
            JSONKey = @"Video";
            errorMessage = SRGILDataProviderLocalizedString(@"Unable to build a valid video object.", nil);
            break;
        case SRGILMediaTypeAudio:
            path = [NSString stringWithFormat:@"audio/play/%@.json", identifier];
            objectClass = [SRGILAudio class];
            JSONKey = @"Audio";
            errorMessage = SRGILDataProviderLocalizedString(@"Unable to build a valid video object.", nil);
            break;

        default:
            NSAssert(NO, @"Wrong to be here.");
            break;
    }

    return [self requestModelObject:objectClass
                               path:path
                            assetId:identifier
                            JSONKey:JSONKey
                       errorMessage:errorMessage
                    completionBlock:completionBlock];
}

- (BOOL)requestLiveMetaInfosForMediaType:(enum SRGILMediaType)mediaType
                             withAssetId:(NSString *)assetId
                         completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock
{
    NSAssert(mediaType == SRGILMediaTypeAudio, @"Unknown for media type other than audio.");
    NSString *path = [NSString stringWithFormat:@"channel/%@/nowAndNext.json", assetId];
    return [self requestModelObject:[SRGILLiveHeaderChannel class]
                               path:path
                            assetId:path // Trying this
                            JSONKey:@"Channel"
                       errorMessage:nil
                    completionBlock:completionBlock];
}

- (BOOL)requestModelObject:(Class)modelClass
                      path:(NSString *)path
                   assetId:(NSString *)identifier
                   JSONKey:(NSString *)JSONKey
              errorMessage:(NSString *)errorMessage
           completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock
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
            for (SRGILRequestMediaCompletionBlock completionBlock in ongoingRequest.completionBlocks) {
                completionBlock(media, error);
            }
        };
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *newError = nil;
                if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -1009) {
                    newError = error;
                }
                else {
                    newError = SRGILCreateUserFacingError(error.localizedDescription, error, SRGILDataProviderErrorCodeInvalidData);
                }
                return callCompletionBlocks(nil, newError);
            });
        }
        else {
            NSError *JSONError = nil;
            id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            if (JSONError) {
                return callCompletionBlocks(nil, JSONError);
            }
            else if (![JSON isKindOfClass:[NSDictionary class]]) {
                JSONError = SRGILCreateUserFacingError(@"Invalid JSON", nil, SRGILDataProviderErrorCodeInvalidData);
                return callCompletionBlocks(nil, JSONError);
            }
            else {
                id media = [[modelClass alloc] initWithDictionary:[(NSDictionary *)JSON valueForKey:JSONKey]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (media) {
                        return callCompletionBlocks(media, nil);
                    }
                    else {
                        NSError *newError = SRGILCreateUserFacingError(errorMessage, nil, SRGILDataProviderErrorCodeInvalidData);
                        return callCompletionBlocks(nil, newError);
                    }
                });
            }
        }
    };
    
    if (!self.URLSession) {
        self.URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        delegate:self
                                                   delegateQueue:nil];
    }
    
    NSURL *completeURL = [self.baseURL URLByAppendingPathComponent:path];
    NSURLSessionTask *task = [self.URLSession dataTaskWithURL:completeURL completionHandler:completion];
    
    ongoingRequest = [[SRGILOngoingRequest alloc] initWithTask:task];
    [ongoingRequest addCompletionBlock:completionBlock];

    self.ongoingRequests[identifier] = ongoingRequest;
    [task resume];
    
    return YES;
}

#pragma mark - Requesting Item Lists

- (BOOL)requestItemsWithURLPath:(NSString *)path
                     onProgress:(SRGILFetchListDownloadProgressBlock)downloadBlock
                   onCompletion:(SRGILRequestArrayCompletionBlock)completionBlock
{
    NSAssert(path, @"An URL path is required, otherwise, what's the point?");
    NSAssert(completionBlock, @"A completion block is required, otherwise, what's the point?");
    
        // Fill dictionary with 0 numbers, as we need the count of requests for the total fraction
    NSNumber *downloadFraction = [self.ongoingVideoListDownloads objectForKey:path];
    if (!downloadFraction) {
        [self.ongoingVideoListDownloads setObject:@(0.0) forKey:path];
    }
    
    NSURL *completeURL = [self.baseURL URLByAppendingPathComponent:path];

    @weakify(self)
    void (^completion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        @strongify(self)
        
        BOOL hasBeenCancelled = (![self.ongoingRequests objectForKey:completeURL]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ongoingRequests removeObjectForKey:completeURL];
            if (self.ongoingRequests.count == 0) {
                [self.ongoingVideoListDownloads removeAllObjects];
                [self.URLSession invalidateAndCancel];
                self.URLSession = nil;
            }
        });
        
        if (!hasBeenCancelled) {
            NSError *JSONError = nil;
            id rawDictionary = nil;
            if (data) {
                rawDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            }
            
            if (error || JSONError || !rawDictionary || ![rawDictionary isKindOfClass:[NSDictionary class]]) {
                NSError *newError = nil;
                if ([error isNetworkError]) {
                    newError = error;
                }
                else if (JSONError) {
                    newError = JSONError;
                }
                else {
                    newError = SRGILCreateUserFacingError(SRGILDataProviderLocalizedString(@"The received data is invalid for category %@", nil), error, SRGILDataProviderErrorCodeInvalidData);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, newError);
                });
            }
            else {
                completionBlock(rawDictionary, nil);
            }
        }
    };
    
    if (!self.URLSession) {
        self.URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        delegate:self
                                                   delegateQueue:nil];
    }

    NSURLSessionTask *task = [self.URLSession dataTaskWithURL:completeURL completionHandler:completion];
    
    SRGILOngoingRequest *ongoingRequest = [[SRGILOngoingRequest alloc] initWithTask:task];
    ongoingRequest.progressBlock = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (totalBytesExpectedToRead >= 0) { // Will be -1 when unknown
            float fraction = (float)bytesRead/(float)totalBytesRead;
            [self.ongoingVideoListDownloads setObject:@(fraction) forKey:completeURL];
        }
        
        if (downloadBlock) {
            NSNumber *sumFractions = [[self.ongoingVideoListDownloads allValues] valueForKeyPath:@"@sum.self"];
            downloadBlock([sumFractions floatValue]/[self.ongoingVideoListDownloads count]);
        }
    };
    
    self.ongoingRequests[completeURL] = ongoingRequest;
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