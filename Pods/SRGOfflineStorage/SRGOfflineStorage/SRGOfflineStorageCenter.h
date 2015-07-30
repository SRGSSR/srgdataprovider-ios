//
//  SRGOfflineStorageCenter.h
//  SRGOfflineStorage
//
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMResults.h>
#import "SRGMetadatasProtocols.h"

extern NSString * const RTSOfflineStorageErrorDomain;

/**
 *  The storage center is the central object of the library. It allows to store metadatas for medias and shows,
 *  along with a "favorite" flag.
 */
@interface SRGOfflineStorageCenter : NSObject

/**
 *  Create if necessary, and returns an instance of the storage center to store metadata.
 *
 *  @param provider The metadata provider
 *
 *  @return The unique instance of the center associated with "Favorites"
 */
+ (SRGOfflineStorageCenter *)favoritesCenterWithMetadataProvider:(id<SRGMetadatasProvider>)provider;

- (RLMResults *)flaggedAsFavoriteMediaMetadatas;
- (RLMResults *)flaggedAsFavoriteShowMetadatas;

- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID;
- (void)flagAsFavorite:(BOOL)favorite showWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID;

- (id<SRGMediaMetadataContainer>)mediaMetadataForIdentifier:(NSString *)identifier;
- (id<SRGShowMetadataContainer>)showMetadataForIdentifier:(NSString *)identifier;

- (RLMResults *)allSavedMediaMetadatas;
- (RLMResults *)allSavedShowMetadatas;

- (void)deleteMediaMetadatasWithIdentifier:(NSString *)identifier;
- (void)deleteShowMetadatasWithIdentifier:(NSString *)identifier;

@end
