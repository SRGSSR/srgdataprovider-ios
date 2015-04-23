//
//  RTSMediaMetadataProvider.h
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTSMediaMetadataContainer <NSObject>

- (NSString *)identifier;
- (NSString *)title;
- (NSString *)parentTitle;
- (NSString *)mediaDescription;
- (NSString *)imageURLString;

- (NSDate *)publicationDate;
- (NSDate *)expirationDate;

- (long)durationInMs;
- (int)viewCount;
- (BOOL)isDownloadable;

@end

@protocol RTSMediaMetadatasProvider <NSObject>

- (id<RTSMediaMetadataContainer>)mediaMetadataContainerForIdentifier:(NSString *)identifier;

@end
