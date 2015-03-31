//
//  SRGRequestManager.m
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <SGVReachability/SGVReachability.h>
#import <AFNetworking/AFNetworking.h>

#import "SRGRequestsManager.h"

#import "SRGILAudio.h"
#import "SRGILVideo.h"
#import "SRGILLiveHeaderChannel.h"
#import "SRGILErrors.h"

NSString * const SRGDebugServerURLKey = @"SRGDebugServerURLKey";
NSString * const SRGDebugServerURLDidChangeNotification = @"SRGDebugServerURLDidChangeNotification";
NSString * const SRGILRequestsManagerBusinessUnitIdentifierKey = @"SRGILRequestsManagerBusinessUnitIdentifierKey";

// The dictionary ongoingVideoListRequests is used by the collection view controller to decide whether all the
// video lists requests are finished before showing an error message or not.


@implementation SRGRequestsManager

+ (instancetype)ILRequestManager
{
    NSString *bu = [[NSUserDefaults standardUserDefaults] stringForKey:SRGILRequestsManagerBusinessUnitIdentifierKey];
    NSAssert(bu, @"Missing business unit identifier");
    
#if TEST || DEBUG || NIGHTLY
    NSURL *baseURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:SRGDebugServerURLKey]];
    if (!baseURL) {
        baseURL = [[NSURL URLWithString:@"http://il.srgssr.ch/integrationlayer/1.0/ue/"] URLByAppendingPathComponent:bu];
    }
#else
    NSURL *baseURL = [[NSURL URLWithString:@"http://il.srgssr.ch/integrationlayer/1.0/ue/"] URLByAppendingPathComponent:bu];
#endif

    return [[SRGRequestsManager alloc] initWithBaseURL:baseURL];
}

- (void)changeBaseURL:(NSURL *)URL businessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    NSString *businessUnitSuffix = [businessUnitIdentifier stringByAppendingString:@"/"];
    NSURL *baseURL = [URL URLByAppendingPathComponent:businessUnitSuffix];
    [self.httpClient setValue:baseURL forKeyPath:@"baseURL"];
}

- (NSString *)businessUnitIdentifier
{
    return [self.httpClient.baseURL lastPathComponent];
}

- (void)setBusinessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    [self changeBaseURL:[self.httpClient.baseURL URLByDeletingLastPathComponent] businessUnitIdentifier:businessUnitIdentifier];
}

//- (BOOL)requestMediaOfType:(SRGMediaType)mediaType withAssetId:(NSString *)assetId completionBlock:(SRGRequestAssetCompletionBlock)completionBlock
//{
//    NSString *path = nil;
//    Class objectClass = NULL;
//    NSString *JSONKey = nil;
//    NSString *errorMessage = nil;
//    
//    switch (mediaType) {
//        case SRGMediaTypeVideo:
//            path = [NSString stringWithFormat:@"video/play/%@.json", assetId];
//            objectClass = [SRGVideo class];
//            JSONKey = @"Video";
//            errorMessage = NSLocalizedString(@"UNABLE_TO_CREATE_VIDEO", nil);
//            break;
//        case SRGMediaTypeAudio:
//            path = [NSString stringWithFormat:@"audio/play/%@.json", assetId];
//            objectClass = [SRGAudio class];
//            JSONKey = @"Audio";
//            errorMessage = NSLocalizedString(@"UNABLE_TO_CREATE_AUDIO", nil);
//            break;
//            
//        default:
//            NSAssert(NO, @"Wrong to be here.");
//            break;
//    }
//    
//    return [self requestModelObject:objectClass
//                               path:path
//                            assetId:assetId
//                            JSONKey:JSONKey
//                       errorMessage:errorMessage
//                    completionBlock:completionBlock];
//}
//
//- (BOOL)requestLiveMetaInfosForMediaType:(SRGMediaType)mediaType withAssetId:(NSString *)assetId completionBlock:(SRGRequestAssetCompletionBlock)completionBlock
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
//
//- (BOOL)requestModelObject:(Class)modelClass
//                      path:(NSString *)path
//                   assetId:(NSString *)assetId
//                   JSONKey:(NSString *)JSONKey
//              errorMessage:(NSString *)errorMessage
//           completionBlock:(SRGRequestAssetCompletionBlock)completionBlock
//{
//    NSAssert(modelClass, @"Missing model class");
//    NSAssert(path, @"Missing model request URL path");
//    NSAssert(assetId, @"Missing asset ID");
//    NSAssert(JSONKey, @"Missing JSON key");
//    NSAssert(completionBlock, @"Missing completion block");
//    
//    if ([self.ongoingAssetRequests objectForKey:assetId]) {
//        return NO;
//    }
//
//    __weak typeof(self) welf = self;
//    void (^completion)(id JSON, NSError *error) = ^(id JSON, NSError *error) {
//        [welf.ongoingAssetRequests removeObjectForKey:assetId];
//
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSError *newError = nil;
//                if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -1009) {
//                    newError = error;
//                }
//                else {
//                    newError = SRGCreateUserFacingError(error.localizedDescription, error, SRGErrorCodeInvalidData);
//                }
//                return completionBlock(nil, newError);
//            });
//        }
//        else {
//            id asset = [[modelClass alloc] initWithDictionary:[JSON valueForKey:JSONKey]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (asset) {
//                    return completionBlock(asset, nil);
//                }
//                else {
//                    NSError *newError = SRGCreateUserFacingError(errorMessage, nil, SRGErrorCodeInvalidData);
//                    return completionBlock(nil, newError);
//                }
//            });
//        }
//    };
//
//    AFHTTPRequestOperation *operation = [self requestOperationWithPath:path completion:completion];
//    self.ongoingAssetRequests[assetId] = operation;
//
//    return YES;
//}

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


@end
