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
@class SRGILURN;
@class SRGILURLComponents;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SRGILRequestListCompletionBlock)(NSDictionary * __nullable rawDictionary, NSError * __nullable error);

@interface SRGILRequestsManager : NSObject

- (id)initWithBusinessUnit:(NSString *)businessUnit;

@property (nonatomic, readonly, copy) NSString *businessUnit;

@property (nonatomic, null_resettable) NSURL *baseURL;

- (id)requestMediaWithURN:(SRGILURN *)URN completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock;

- (id)requestLiveMetaInfosWithChannelID:(NSString *)channelID livestreamID:(nullable NSString *)livestreamID completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock;

- (id)requestShowWithIdentifier:(NSString *)identifier completionBlock:(SRGILFetchObjectCompletionBlock)completionBlock;

- (id)requestObjectsListWithURLComponents:(SRGILURLComponents *)components
                              progressBlock:(nullable SRGILFetchListDownloadProgressBlock)progressBlock
                            completionBlock:(SRGILRequestListCompletionBlock)completionBlock;

- (void)cancelRequest:(id)request;

- (void)sendViewCountUpdate:(NSString *)identifier forMediaTypeName:(NSString *)mediaType;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using the WIFI or not.
 */
+ (BOOL)isUsingWIFI;

/**
 *  Return YES iff online
 */
+ (BOOL)isOnline;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Returns the SSID string of the current WIFI, if 'isUsingWIFI' returns 'YES'.
 *  Returns nil otherwise.
 */
+ (nullable NSString *)WIFISSID;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using a Swisscom WIFI.
 *  Returns 'NO' if the method 'isUsingWIFI' returns 'NO', obviously.
 */
+ (BOOL)isUsingSwisscomWIFI;

@end

NS_ASSUME_NONNULL_END
