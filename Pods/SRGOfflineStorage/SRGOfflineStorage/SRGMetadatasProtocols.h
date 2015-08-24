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

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *imageURLString;
@property (nonatomic, readonly) NSString *audioChannelID;

@property (nonatomic, readonly) NSDate *expirationDate;
@property (nonatomic, readonly) NSDate *favoriteChangeDate;

@property (nonatomic, readonly) BOOL isFavorite;

@end

/**
 *  The specialized metadata container protocol for Medias.
 */
@protocol SRGMediaMetadataContainer <SRGBaseMetadataContainer>

@property (nonatomic, readonly) NSString *parentTitle;
@property (nonatomic, readonly) NSString *mediaDescription;

@property (nonatomic, readonly) NSDate *publicationDate;

@property (nonatomic, readonly) NSInteger type;
@property (nonatomic, readonly) long durationInMs;
@property (nonatomic, readonly) int viewCount;
@property (nonatomic, readonly) BOOL isDownloadable;

@property (nonatomic, readonly) BOOL isDownloading;
@property (nonatomic, readonly) BOOL isDownloaded;

@property (nonatomic, readonly) NSString *downloadURLString;
@property (nonatomic, readonly) NSString *localURLString;

@end

/**
 *  The specialized metadata container protocol for Shows.
 */
@protocol SRGShowMetadataContainer <SRGBaseMetadataContainer>

@property (nonatomic, readonly) NSString *showDescription;

@end
