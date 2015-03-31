//
//  SRGRequestManager.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILList.h"
#import "SRGILErrors.h"
#import "SRGILModelConstants.h"
#import "SRGBaseRequestsManager.h"

extern NSString * const SRGDebugServerURLDidChangeNotification;
extern NSString * const SRGDebugServerURLKey;

extern NSString * const SRGILRequestsManagerBusinessUnitIdentifierKey;

@class SRGILList;

// Completion blocks
typedef void (^SRGRequestArrayCompletionBlock)(id<NSCopying>tag, SRGILList *items, Class itemClass, NSError *error);
typedef void (^SRGRequestAssetCompletionBlock)(id asset, NSError *error);
typedef void (^SRGRequestDownloadProgressBlock)(float fraction);

/**
 * An instance of SRGRequestManager represents the entry point to an Integration Layer webserver (with base URL
 * provided at creation time)
 */
@interface SRGRequestsManager : SRGBaseRequestsManager

/**
 * Creates and returns a new request manager to be used with the Integration Layer of the SRG.
 *
 *  @param key A 3-letters string identifiying the BU of the SRG SSR MUST be set in the standard user defaults
 *  using the SRGILRequestsManagerBusinessUnitIdentifierKey key.
 */
+ (instancetype)ILRequestManager;

/**
 *  The business unit identifier is a string appended to the base URL of the request manager.
 *  When using the ILRequestManager, it is set by default.
 */
@property(nonatomic, strong) NSString *businessUnitIdentifier;

/**
 *  Request a given video
 *
 *  @param completionBlock In case of success, contains an the asset.
 *
 *  @return A boolean indicating wether the request is being started or not.
 */
//- (BOOL)requestMediaOfType:(SRGILMediaType)mediaType withAssetId:(NSString *)assetId completionBlock:(SRGRequestAssetCompletionBlock)completionBlock;


//- (BOOL)requestLiveMetaInfosForMediaType:(SRGILMediaType)mediaType withAssetId:(NSString *)assetId completionBlock:(SRGRequestAssetCompletionBlock)completionBlock;

/**
 *  Update the view count for a given video
 *
 *  @param videoURN        URN of the video
 *  @param completionBlock Empty completion block, except for possible errors
 *
 */
//- (void)sendViewCountUpdate:(NSString *)assetId forMediaTypeName:(NSString *)mediaType;

@end

