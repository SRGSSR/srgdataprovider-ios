//
//  SRGOfflineStorageCenter.h
//  SRGOfflineStorage
//
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMResults.h>
#import "SRGMetadatasProtocols.h"
#import "SRGDownloadProtocol.h"

extern NSString * const RTSOfflineStorageErrorDomain;

/**
 *  The storage center is the central object of the library. It allows to store metadatas for medias and shows,
 *  along with a "favorite" flag.
 */
@interface SRGOfflineStorageCenter : NSObject

@property(nonatomic, weak) id<SRGDownloadDelegate> delegate;

/**
 *  Create if necessary, and returns an instance of the storage center to store metadata.
 *
 *  @return The unique instance of the Offline center associated with "Favorites"
 */
+ (SRGOfflineStorageCenter *)favoritesOffineStorageCenter;

- (id<SRGMediaMetadataContainer>)mediaMetadataForIdentifier:(NSString *)identifier;
- (id<SRGShowMetadataContainer>)showMetadataForIdentifier:(NSString *)identifier;

- (NSArray *)allSavedMediaMetadatas; // Array of (id<SRGMediaMetadataContainer>)
- (NSArray *)allSavedShowMetadatas; // Array of (id<SRGShowMetadataContainer>)

- (void)deleteMediaMetadatasWithIdentifier:(NSString *)identifier;
- (void)deleteShowMetadatasWithIdentifier:(NSString *)identifier;

/**
 *  Favorites
 */
- (NSArray *)flaggedAsFavoriteMediaMetadatas; // Array of (id<SRGMediaMetadataContainer>)
- (NSArray *)flaggedAsFavoriteShowMetadatas; // Array of (id<SRGShowMetadataContainer>)

- (void)flagAsFavorite:(BOOL)favorite mediaMetadata:(id<SRGMediaMetadataContainer>)mediaMetadata;
- (void)flagAsFavorite:(BOOL)favorite showMetadata:(id<SRGShowMetadataContainer>)showMetadatar;


/**
 *  Downloads
 */

- (NSArray *)flaggedAsDownloadedMediaMetadatas; // Array of (id<SRGMediaMetadataContainer>)
- (NSArray *)flaggedAsDownloadingMediaMetadatas; // Array of (id<SRGMediaMetadataContainer>)
- (NSArray *)flaggedAsDownloadingOrDownloadedMediaMetadatas; // Array of (id<SRGMediaMetadataContainer>)

- (void)markForDownload:(BOOL)download mediaMetadata:(id<SRGMediaMetadataContainer>)mediaMetadata;  // If markForDownload is set to YES, it starts or resume the download
                                                                                                    // If markForDownload is set to NO, it suspends the download. File are only removed when unfavorite the media

@end
