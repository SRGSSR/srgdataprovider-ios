//
//  RTSOfflineStorageCenter.h
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTSMediaMetadatasProtocols.h"
#import <Realm/RLMResults.h>

@interface RTSOfflineStorageCenter : NSObject

+ (RTSOfflineStorageCenter *)favoritesCenterWithMetadataProvider:(id<RTSMediaMetadatasProvider>)provider;

- (RLMResults *)flaggedAsFavoriteMetadatas;
- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier;

- (void)saveMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error;
- (void)deleteMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error;
- (NSSet *)savedMediaMetadataIdentifiers;
- (RLMResults *)savedMediaMetadatas;


@end
