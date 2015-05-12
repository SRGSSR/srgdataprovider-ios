//
//  SRGILDataProvider+OfflineStorage.h
//  SRGILDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider.h"
#import <RTSOfflineMediaStorage/RTSOfflineMediaStorage.h>

@interface SRGILDataProvider (OfflineStorage) <RTSMetadatasProvider>

- (BOOL)isMediaFlaggedAsFavorite:(NSString *)identifier;
- (BOOL)isShowFlaggedAsFavorite:(NSString *)identifier;

- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID;
- (void)flagAsFavorite:(BOOL)favorite showWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID;

- (NSArray *)flaggedAsFavoriteMediaMetadatas;
- (NSArray *)flaggedAsFavoriteShowMetadatas;

- (void)extractLocalItemsOfIndex:(SRGILFetchListIndex)index onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

@end
