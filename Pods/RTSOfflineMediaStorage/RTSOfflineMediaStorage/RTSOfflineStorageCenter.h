//
//  RTSOfflineStorageCenter.h
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTSMediaMetadatasProtocols.h"

@interface RTSOfflineStorageCenter : NSObject

@property(nonatomic, strong) id<RTSMediaMetadatasProvider> metadatasProvider;

+ (RTSOfflineStorageCenter *)favoritesSharedCenter;

- (void)saveMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error;
- (void)deleteMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error;

- (NSSet *)storedMediaMetadataIdentifiers;

/*
 * Returns an array of id<RTSMediaMetadataContainer> instances.
 */
- (NSArray *)storedMediaMetadatas;

@end
