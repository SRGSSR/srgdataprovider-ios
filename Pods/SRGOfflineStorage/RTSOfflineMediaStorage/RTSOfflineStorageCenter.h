//
//  SRGOfflineStorageCenter.h
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMResults.h>
#import "RTSMetadatasProtocols.h"

@interface RTSOfflineStorageCenter : NSObject

+ (RTSOfflineStorageCenter *)favoritesCenterWithMetadataProvider:(id<RTSMetadatasProvider>)provider;

- (RLMResults *)flaggedAsFavoriteMediaMetadatas;
- (RLMResults *)flaggedAsFavoriteShowMetadatas;

- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID;
- (void)flagAsFavorite:(BOOL)favorite showWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID;

- (id<RTSMediaMetadataContainer>)mediaMetadataForIdentifier:(NSString *)identifier;
- (id<RTSShowMetadataContainer>)showMetadataForIdentifier:(NSString *)identifier;

- (RLMResults *)allSavedMediaMetadatas;
- (RLMResults *)allSavedShowMetadatas;


@end
