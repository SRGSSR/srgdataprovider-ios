//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"
#import "SRGILDataProvider.h"

@class SRGILMedia;
@class SRGILList;

typedef void (^SRGILRequestArrayCompletionBlock)(NSDictionary *rawDictionary, NSError *error);

@interface SRGILRequestsManager : NSObject

- (id)initWithBusinessUnit:(NSString *)businessUnit;

- (NSString *)businessUnit;
- (NSURL *)baseURL;

- (BOOL)requestMediaOfType:(enum SRGILMediaType)mediaType
            withIdentifier:(NSString *)assetIdentifier
           completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock;

- (BOOL)requestShowWithIdentifier:(NSString *)identifier
                     onCompletion:(SRGILRequestMediaCompletionBlock)completionBlock;

- (BOOL)requestLiveMetaInfosForMediaType:(enum SRGILMediaType)mediaType
                             withAssetId:(NSString *)assetId
                         completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock;

- (BOOL)requestItemsWithURLPath:(NSString *)path
                     onProgress:(SRGILFetchListDownloadProgressBlock)downloadBlock
                   onCompletion:(SRGILRequestArrayCompletionBlock)completionBlock;

- (void)cancelAllRequests;

- (void)sendViewCountUpdate:(NSString *)identifier forMediaTypeName:(NSString *)mediaType;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using the WIFI or not.
 */
+ (BOOL)isUsingWIFI;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Returns the SSID string of the current WIFI, if 'isUsingWIFI' returns 'YES'.
 *  Returns nil otherwise.
 */
+ (NSString *)WIFISSID;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using a Swisscom WIFI.
 *  Returns 'NO' if the method 'isUsingWIFI' returns 'NO', obviously.
 */
+ (BOOL)isUsingSwisscomWIFI;

@end