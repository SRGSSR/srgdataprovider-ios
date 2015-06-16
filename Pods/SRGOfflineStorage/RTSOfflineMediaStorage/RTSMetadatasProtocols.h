//
//  RTSMediaMetadataProvider.h
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTSBaseMetadataContainer <NSObject>

- (NSString *)identifier;
- (NSString *)title;
- (NSString *)imageURLString;
- (NSString *)audioChannelID;

- (NSDate *)expirationDate;
- (NSDate *)favoriteChangeDate;

- (BOOL)isFavorite;

@end


@protocol RTSMediaMetadataContainer <RTSBaseMetadataContainer>

- (NSString *)parentTitle;
- (NSString *)mediaDescription;

- (NSDate *)publicationDate;

- (NSInteger)type;
- (long)durationInMs;
- (int)viewCount;
- (BOOL)isDownloadable;

@end

@protocol RTSShowMetadataContainer <RTSBaseMetadataContainer>

- (NSString *)showDescription;

@end

@protocol RTSMetadatasProvider <NSObject>

- (id<RTSMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier;
- (id<RTSShowMetadataContainer>)showMetadataContainerForIdentifier:(NSString *)identifier;

@end
