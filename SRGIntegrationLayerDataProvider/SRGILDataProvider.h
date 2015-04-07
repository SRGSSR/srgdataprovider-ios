//
//  SRGILMediaPlayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <RTSAnalytics/RTSAnalyticsDataSource.h>

@class SRGILList;

typedef NS_ENUM(NSInteger, SRGILModelDataOrganisationType) {
    SRGILModelDataOrganisationTypeFlat,
    SRGILModelDataOrganisationTypeAlphabetical,
};

typedef NS_ENUM(NSInteger, SRGILModelItemType) {
    SRGILModelItemTypeVideoLiveStreams,
};


typedef void (^SRGILFetchListDownloadProgressBlock)(float fraction);
typedef void (^SRGILFetchListCompletionBlock)(SRGILList *items, Class itemClass, NSError *error);

@interface SRGILDataProvider : NSObject <RTSMediaPlayerControllerDataSource, RTSAnalyticsDataSource>

+ (NSString *)comScoreVirtualSite:(NSString *)businessUnit;
+ (NSString *)streamSenseVirtualSite:(NSString *)businessUnit;

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit;
- (NSString *)businessUnit;

- (void)fetchFlatListOfItemType:(enum SRGILModelItemType)itemType
                   onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

- (void)fetchListOfItemType:(enum SRGILModelItemType)itemType
                  organised:(SRGILModelDataOrganisationType)orgType
                 onProgress:(SRGILFetchListDownloadProgressBlock)progressBlock
               onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

@end
