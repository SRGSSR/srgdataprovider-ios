//
// Created by Sebastien Chauvin on 26/11/14.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"

@class SRGILMedia;
@class SRGILList;

typedef void (^SRGRequestMediaCompletionBlock)(SRGILMedia *media, NSError *error);

@interface SRGILRequestsManager : NSObject

- (id)initWithBusinessUnit:(NSString *)businessUnit;

- (NSString *)businessUnit;
- (NSURL *)baseURL;

- (BOOL)requestMediaOfType:(enum SRGILMediaType)mediaType withIdentifier:(NSString *)assetIdentifier completionBlock:(SRGRequestMediaCompletionBlock)completionBlock;
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