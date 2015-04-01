//
// Created by Sebastien Chauvin on 26/11/14.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <SGVReachability/SGVReachability.h>
#import <AFNetworking/AFNetworking.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILRequestsManager.h"

#import "SRGILModel.h"
#import "SRGILErrors.h"
#import "SRGILList.h"

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

//- (BOOL)requestItemsWithURLPath:(NSString *)path
//                         forTag:(id<NSCopying>)tag
//               organisationType:(SRGModelDataOrganisationType)orgType
//                     onProgress:(SRGRequestDownloadProgressBlock)downloadBlock
//                   onCompletion:(SRGRequestArrayCompletionBlock)completionBlock
//{
//    NSAssert(path, @"An URL path is required, otherwise, what's the point?");
//    NSAssert(completionBlock, @"A completion block is required, otherwise, what's the point?");
//
//    NSLog(@"[Info] Requesting items for tag %@ with path %@", tag, path);
//
//    // Fill dictionary with 0 numbers, as we need the count of requests for the total fraction
//    NSNumber *downloadFraction = [self.ongoingVideoListDownloads objectForKey:path];
//    if (!downloadFraction) {
//        [self.ongoingVideoListDownloads setObject:@(0.0) forKey:path];
//    }
//
//    __weak typeof(self) welf = self;
//    void (^completion)(id rawDictionary, NSError *error) = ^(id rawDictionary, NSError *error) {
//        BOOL hasBeenCancelled = (![welf.ongoingVideoListRequests objectForKey:path]);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [welf.ongoingVideoListRequests removeObjectForKey:path];
//            if ([welf.ongoingVideoListRequests count] == 0) {
//                [welf.ongoingVideoListDownloads removeAllObjects];
//            }
//        });
//
//        if (!hasBeenCancelled) {
//            if (error || !rawDictionary || ![rawDictionary isKindOfClass:[NSDictionary class]]) {
//                id<NSCopying>tagCopy = tag;
//                NSError *newError = nil;
//                if ([error isNetworkError]) {
//                    newError = error;
//                }
//                else {
//                    NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"INVALID_DATA_FOR_CATEGORY", nil), tag];
//                    newError = SRGCreateUserFacingError(reason, error, SRGErrorCodeInvalidData);
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(tagCopy, nil, nil, newError);
//                });
//                return;
//            }
//
//            [welf extractItemsAndClassNameFromRawDictionary:rawDictionary
//                                                     forTag:tag
//                                           organisationType:orgType
//                                        withCompletionBlock:completionBlock];
//        }
//    };
//
//    void (^progress)(NSUInteger, long long, long long) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        if (totalBytesExpectedToRead >= 0) { // Will be -1 when unknown
//            float fraction = (float)bytesRead/(float)totalBytesRead;
//            [welf.ongoingVideoListDownloads setObject:@(fraction) forKey:path];
//        }
//
//        if (downloadBlock) {
//            NSNumber *sumFractions = [[welf.ongoingVideoListDownloads allValues] valueForKeyPath:@"@sum.self"];
//            downloadBlock([sumFractions floatValue]/[welf.ongoingVideoListDownloads count]);
//        }
//    };
//
//    AFHTTPRequestOperation *operation = [self requestOperationWithPath:path completion:completion];
//    [operation setDownloadProgressBlock:progress];
//    self.ongoingVideoListRequests[path] = operation;
//
//    return YES;
//}

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

//- (void)extractItemsAndClassNameFromRawDictionary:(NSDictionary *)rawDictionary
//                                           forTag:(id<NSCopying>)tag
//                                 organisationType:(SRGModelDataOrganisationType)orgType
//                              withCompletionBlock:(SRGRequestArrayCompletionBlock)completionBlock
//{
//    if ([[rawDictionary allKeys] count] != 1) {
//        // As for now, we will only extract items from a dictionary that has a single key/value pair.
//        [self sendUserFacingErrorForTag:tag withTechError:nil completionBlock:completionBlock];
//        return;
//    }
//
//    // The only way to distinguish an array of items with the dictionary of a single item, is to parse the main
//    // dictionary and see if we can build an _array_ of the following class names. This is made necessary due to the
//    // change of semantics from XML to JSON.
//    NSArray *validItemClassKeys = @[@"Video", @"Show", @"AssetSet", @"Audio"];
//
//    NSString *mainKey = [[rawDictionary allKeys] lastObject];
//    NSDictionary *mainValue = [[rawDictionary allValues] lastObject];
//
//    __block NSString *className = nil;
//    __block NSArray *itemsDictionaries = nil;
//    NSMutableDictionary *globalProperties = [NSMutableDictionary dictionary];
//
//    [mainValue enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
//        if (NSClassFromString([@"SRG" stringByAppendingString:key]) && // We have an Obj-C class to build with
//            [validItemClassKeys containsObject:key] && // It is among the known class keys
//            [obj isKindOfClass:[NSArray class]]) // Its value is an array of siblings.
//        {
//            className = key;
//            itemsDictionaries = [mainValue objectForKey:className];
//        }
//        else if ([key length] > 1 && [key hasPrefix:@"@"]) {
//            [globalProperties setObject:obj forKey:[key substringFromIndex:1]];
//        }
//    }];
//
//
//    // We haven't found an array of items. The root object is probably what we are looking for.
//    if (!className && NSClassFromString([@"SRG" stringByAppendingString:mainKey])) {
//        className = mainKey;
//        itemsDictionaries = @[mainValue];
//    }
//
//    if (!className) {
//        [self sendUserFacingErrorForTag:tag withTechError:nil completionBlock:completionBlock];
//    }
//    else {
//        Class itemClass = NSClassFromString([@"SRG" stringByAppendingString:className]);
//
//        SRGModelDataOrganiser *organiser = [[SRGModelDataOrganiser alloc] init];
//
//        NSError *error = nil;
//        NSArray *organisedItems = [organiser organiseItemsWithGlobalProperties:globalProperties
//                                                               rawDictionaries:itemsDictionaries
//                                                                       forTag:tag
//                                                              organisationType:orgType
//                                                                   modelClass:itemClass
//                                                                        error:&error];
//
//        if (error) {
//            [self sendUserFacingErrorForTag:tag withTechError:error completionBlock:completionBlock];
//        }
//        else {
//            NSLog(@"[Info] Returning %tu organised data item for tag %@", [organisedItems count], tag);
//
//            for (SRGOrganisedModelDataItem *dataItem in organisedItems) {
//                id<NSCopying> newTag = dataItem.tag;
//                SRGILList *newItems = dataItem.items;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(newTag, newItems, itemClass, nil);
//                });
//            }
//        }
//    }
//}

//- (void)sendUserFacingErrorForTag:(id<NSCopying>)tag
//                    withTechError:(NSError *)error
//                  completionBlock:(SRGRequestArrayCompletionBlock)completionBlock
//{
//    id<NSCopying>tagCopy = tag;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"INVALID_DATA_FOR_CATEGORY", nil), tag];
//        NSError *newError = SRGCreateUserFacingError(reason, error, SRGErrorCodeInvalidData);
//        completionBlock(tagCopy, nil, nil, newError);
//    });
//}

//+ (NSDate *)downloadDateForKey:(NSString *)key
//{
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
//        NSInteger seconds = [[NSUserDefaults standardUserDefaults] integerForKey:key];
//        return [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
//    }
//    return referenceDate();
//}
//
//+ (void)refreshDownloadDateForKey:(NSString *)key
//{
//    [[NSUserDefaults standardUserDefaults] setInteger:[[NSDate date] timeIntervalSinceReferenceDate] forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}


- (BOOL)requestMediaOfType:(enum SRGILMediaType)mediaType withIdentifier:(NSString *)identifier completionBlock:(SRGRequestMediaCompletionBlock)completionBlock
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
//
//- (BOOL)requestLiveMetaInfosForMediaType:(SRGMediaType)mediaType withAssetId:(NSString *)assetId completionBlock:(SRGRequestMediaCompletionBlock)completionBlock
//{
//    NSAssert(mediaType == SRGMediaTypeAudio, @"Unknown for media type other than audio.");
//    NSString *path = [NSString stringWithFormat:@"channel/%@/nowAndNext.json", assetId];
//    return [self requestModelObject:[SRGLiveHeaderChannel class]
//                               path:path
//                            assetId:path // Trying this
//                            JSONKey:@"Channel"
//                       errorMessage:nil
//                    completionBlock:completionBlock];
//}

- (BOOL)requestModelObject:(Class)modelClass
                      path:(NSString *)path
                   assetId:(NSString *)identifier
                   JSONKey:(NSString *)JSONKey
              errorMessage:(NSString *)errorMessage
           completionBlock:(SRGRequestMediaCompletionBlock)completionBlock
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

//- (void)sendViewCountUpdate:(NSString *)assetId forMediaTypeName:(NSString *)mediaType
//{
//    NSParameterAssert(assetId);
//
//    NSString *path = [NSString stringWithFormat:@"%@/%@/clicked.json", mediaType, assetId];
//    [self.httpClient postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"[Debug] View count update success for asset ID: %@", assetId);
//    }                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"[Error] View count failed for asset ID:%@ with error: %@", assetId, [error localizedDescription]);
//    }];
//}


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