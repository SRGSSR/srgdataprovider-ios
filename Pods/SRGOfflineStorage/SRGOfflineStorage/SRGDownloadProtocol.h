//
//  SRGDownloadProtocol.h
//  SRGOfflineStorage
//
//  Created by Cédric Foellmi on 20/08/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRGOfflineStorageCenter;

@protocol SRGDownloadDelegate <NSObject>

- (void)storageCenter:(SRGOfflineStorageCenter *)center willStartDownloading:(NSString *)identifier;
- (void)storageCenter:(SRGOfflineStorageCenter *)center isDownloading:(NSString *)identifier progress:(float)progress total:(long long)total;
- (void)storageCenter:(SRGOfflineStorageCenter *)center finishedDownloading:(NSString *)identifier withLocalURLString:(NSString *)localURLString;

@end
