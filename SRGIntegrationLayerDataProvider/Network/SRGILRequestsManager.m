//
// Created by Sebastien Chauvin on 26/11/14.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <SGVReachability/SGVReachability.h>
#import <AFNetworking/AFNetworking.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <libextobjc/EXTScope.h>

#import "SRGILDataProvider.h"
#import "SRGILRequestsManager.h"
#import "SRGILOrganisedModelDataItem.h"

#import "SRGILModel.h"
#import "SRGILErrors.h"
#import "SRGILList.h"


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

@interface SRGILRequestsManager ()
@property (nonatomic, strong) AFHTTPClient *httpClient;
@property (nonatomic, strong) NSMutableDictionary *ongoingVideoListRequests;
@property (nonatomic, strong) NSMutableDictionary *ongoingVideoListDownloads;
@property (nonatomic, strong) NSMutableDictionary *ongoingAssetRequests;
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
        NSURL *baseURL = [[NSURL URLWithString:@"http://il.srgssr.ch/integrationlayer/1.0/ue/"] URLByAppendingPathComponent:businessUnit];
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [self.httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self.httpClient setDefaultHeader:@"Accept" value:@"application/json"];

        self.ongoingVideoListRequests = [NSMutableDictionary dictionary];
        self.ongoingVideoListDownloads = [NSMutableDictionary dictionary];
        self.ongoingAssetRequests = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)businessUnit
{
    return [self.httpClient.baseURL lastPathComponent];
}

- (NSURL *)baseURL
{
    return self.httpClient.baseURL;
}


- (NSArray *)ongoingRequestPaths
{
    return [self.ongoingVideoListRequests allKeys];
}

- (AFHTTPRequestOperation *)requestOperationWithPath:(NSString *)path completion:(void (^)(id JSON, NSError *error))completion
{
    NSURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFHTTPRequestOperation *operation = [self.httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil; // Avoid caching response.
    }];
    [self.httpClient enqueueHTTPRequestOperation:operation];
    
    DDLogDebug(@"<%p> Requesting URL: %@", self, request.URL);

    return operation;
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
            errorMessage = NSLocalizedString(@"UNABLE_TO_CREATE_VIDEO", nil);
            break;
        case SRGILMediaTypeAudio:
            path = [NSString stringWithFormat:@"audio/play/%@.json", identifier];
            objectClass = [SRGILAudio class];
            JSONKey = @"Audio";
            errorMessage = NSLocalizedString(@"UNABLE_TO_CREATE_AUDIO", nil);
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

    if ([self.ongoingAssetRequests objectForKey:identifier]) {
        return NO;
    }

    __weak typeof(self) welf = self;
    void (^completion)(id JSON, NSError *error) = ^(id JSON, NSError *error) {
        [welf.ongoingAssetRequests removeObjectForKey:identifier];

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *newError = nil;
                if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -1009) {
                    newError = error;
                }
                else {
                    newError = SRGILCreateUserFacingError(error.localizedDescription, error, SRGILErrorCodeInvalidData);
                }
                return completionBlock(nil, newError);
            });
        }
        else {
            id media = [[modelClass alloc] initWithDictionary:[JSON valueForKey:JSONKey]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (media) {
                    return completionBlock(media, nil);
                }
                else {
                    NSError *newError = SRGILCreateUserFacingError(errorMessage, nil, SRGILErrorCodeInvalidData);
                    return completionBlock(nil, newError);
                }
            });
        }
    };

    AFHTTPRequestOperation *operation = [self requestOperationWithPath:path completion:completion];
    self.ongoingAssetRequests[identifier] = operation;

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
    
    @weakify(self)
    
    void (^completion)(id rawDictionary, NSError *error) = ^(id rawDictionary, NSError *error) {
        @strongify(self)
        
        BOOL hasBeenCancelled = (![self.ongoingVideoListRequests objectForKey:path]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ongoingVideoListRequests removeObjectForKey:path];
            if ([self.ongoingVideoListRequests count] == 0) {
                [self.ongoingVideoListDownloads removeAllObjects];
            }
        });
        
        if (!hasBeenCancelled) {
            if (error || !rawDictionary || ![rawDictionary isKindOfClass:[NSDictionary class]]) {
                NSError *newError = nil;
                if ([error isNetworkError]) {
                    newError = error;
                }
                else {
                    newError = SRGILCreateUserFacingError(NSLocalizedString(@"INVALID_DATA_FOR_CATEGORY", nil), error, SRGILErrorCodeInvalidData);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, newError);
                });
                return;
            }
            
            completionBlock(rawDictionary, nil);
        }
    };
    
    void (^progress)(NSUInteger, long long, long long) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (totalBytesExpectedToRead >= 0) { // Will be -1 when unknown
            float fraction = (float)bytesRead/(float)totalBytesRead;
            [self.ongoingVideoListDownloads setObject:@(fraction) forKey:path];
        }
        
        if (downloadBlock) {
            NSNumber *sumFractions = [[self.ongoingVideoListDownloads allValues] valueForKeyPath:@"@sum.self"];
            downloadBlock([sumFractions floatValue]/[self.ongoingVideoListDownloads count]);
        }
    };
    
    AFHTTPRequestOperation *operation = [self requestOperationWithPath:path completion:completion];
    [operation setDownloadProgressBlock:progress];
    self.ongoingVideoListRequests[path] = operation;
    
    return YES;
}

#pragma mark - View Count

- (void)sendViewCountUpdate:(NSString *)identifier forMediaTypeName:(NSString *)mediaType
{
    NSParameterAssert(identifier);

    NSString *path = [NSString stringWithFormat:@"%@/%@/clicked.json", mediaType, identifier];
    [self.httpClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogDebug(@"View count update success for asset ID: %@", identifier);
    }                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"View count failed for asset ID:%@ with error: %@", identifier, [error localizedDescription]);
    }];
}

#pragma mark - Operations

- (void)cancelAllRequests
{
    if ([self.ongoingVideoListRequests count] == 0 && [self.ongoingAssetRequests count] == 0) {
        return;
    }
    
    DDLogInfo(@"Cancelling all (%lu) requests.", (unsigned long)[self.ongoingVideoListRequests count]+[self.ongoingAssetRequests count]);
    
    [[self.ongoingVideoListRequests allValues] makeObjectsPerformSelector:@selector(cancel)];
    [[self.ongoingAssetRequests allValues] makeObjectsPerformSelector:@selector(cancel)];
    [self.ongoingAssetRequests removeAllObjects];
    [self.ongoingVideoListRequests removeAllObjects];
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