//
//  RTSMediaMetadataProvider.h
//  SRGOfflineStorage
//
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This is the common base metadata container protocol describing properties shared by Medias and Shows.
 */
@protocol SRGBaseMetadataContainer <NSObject>

- (NSString *)identifier;
- (NSString *)title;
- (NSString *)imageURLString;
- (NSString *)audioChannelID;

- (NSDate *)expirationDate;
- (NSDate *)favoriteChangeDate;

- (BOOL)isFavorite;

@end

/**
 *  The specialized metadata container protocol for Medias.
 */
@protocol SRGMediaMetadataContainer <SRGBaseMetadataContainer>

- (NSString *)parentTitle;
- (NSString *)mediaDescription;

- (NSDate *)publicationDate;

- (NSInteger)type;
- (long)durationInMs;
- (int)viewCount;
- (BOOL)isDownloadable;

@end

/**
 *  The specialized metadata container protocol for Shows.
 */
@protocol SRGShowMetadataContainer <SRGBaseMetadataContainer>

- (NSString *)showDescription;

@end


/**
 *  The protocol that defaines what a metadata provider must implement for the storage to work.
 */
@protocol SRGMetadatasProvider <NSObject>

- (id<SRGMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier;
- (id<SRGShowMetadataContainer>)showMetadataContainerForIdentifier:(NSString *)identifier;

@end
