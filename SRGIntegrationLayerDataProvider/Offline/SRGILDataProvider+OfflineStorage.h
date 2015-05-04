//
//  SRGILDataProvider+OfflineStorage.h
//  SRGILDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider.h"
#import <RTSOfflineMediaStorage/RTSOfflineMediaStorage.h>

@interface SRGILDataProvider (OfflineStorage) <RTSMediaMetadatasProvider>

- (void)saveMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error;
- (void)deleteMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error;

- (void)extractLocalItemsOfType:(SRGILFetchList)itemType onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

@end
