//
//  SRGILMediaPlayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSAnalytics/RTSAnalytics.h>
#import <RTSMediaPlayer/RTSMediaPlayer.h>

@class SRGILList;

typedef NS_ENUM(NSInteger, SRGILModelDataOrganisationType) {
    SRGILModelDataOrganisationTypeFlat,
    SRGILModelDataOrganisationTypeAlphabetical,
};

typedef NS_ENUM(NSInteger, SRGILFetchList) {
    SRGILFetchListVideoLiveStreams,
    SRGILFetchListVideoEditorialPicks,
    SRGILFetchListVideoMostRecent,
    SRGILFetchListVideoMostSeen,
    SRGILFetchListVideoShowsAZ,
    SRGILFetchListVideoShowsAZDetail,
    SRGILFetchListVideoShowsByDate,
    SRGILFetchListMediaFavorite,
    SRGILFetchListAudioLiveStreams,
    SRGILFetchListAudioMostRecent,
    SRGILFetchListAudioMostListened,
    SRGILFetchListAudioShowsAZ,
    SRGILFetchListAudioShowsAZDetail
};

static const float DOWNLOAD_PROGRESS_DONE = 1.0;

typedef void (^SRGILFetchListDownloadProgressBlock)(float fraction);
typedef void (^SRGILFetchListCompletionBlock)(SRGILList *items, Class itemClass, NSError *error);

@interface SRGILDataProvider : NSObject <RTSMediaPlayerControllerDataSource, RTSAnalyticsMediaPlayerDataSource>

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit;
- (NSString *)businessUnit;

- (NSUInteger)ongoingFetchCount;

- (BOOL)isFetchPathValidForType:(enum SRGILFetchList)itemType;

- (void)resetFetchPathForType:(enum SRGILFetchList)itemType;

- (void)fetchFlatListOfType:(enum SRGILFetchList)itemType
               onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

- (void)fetchListOfType:(enum SRGILFetchList)itemType
       withPathArgument:(id)arg
              organised:(SRGILModelDataOrganisationType)orgType
             onProgress:(SRGILFetchListDownloadProgressBlock)progressBlock
        onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

@end
