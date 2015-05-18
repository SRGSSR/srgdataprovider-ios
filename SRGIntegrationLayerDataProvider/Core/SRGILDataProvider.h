//
//  SRGILMediaPlayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSMediaPlayer/RTSMediaPlayer.h>
#import <RTSAnalytics/RTSAnalytics.h>

@class SRGILList;

typedef NS_ENUM(NSInteger, SRGILModelDataOrganisationType) {
    SRGILModelDataOrganisationTypeFlat,
    SRGILModelDataOrganisationTypeAlphabetical,
};

typedef NS_ENUM(NSInteger, SRGILFetchListIndex) {
    SRGILFetchListVideoLiveStreams,
    SRGILFetchListVideoEditorialPicks,
    SRGILFetchListVideoMostRecent,
    SRGILFetchListVideoMostSeen,
    SRGILFetchListVideoShowsAZ,
    SRGILFetchListVideoShowsAZDetail,
    SRGILFetchListVideoShowsByDate,
    SRGILFetchListAudioLiveStreams,
    SRGILFetchListAudioMostRecent,
    SRGILFetchListAudioMostListened,
    SRGILFetchListAudioShowsAZ,
    SRGILFetchListAudioShowsAZDetail,
    SRGILFetchListMediaFavorite,
    SRGILFetchListShowFavorite
};

static const float DOWNLOAD_PROGRESS_DONE = 1.0;

typedef void (^SRGILFetchListDownloadProgressBlock)(float fraction);
typedef void (^SRGILFetchListCompletionBlock)(SRGILList *items, Class itemClass, NSError *error);

@interface SRGILDataProvider : NSObject <RTSMediaPlayerControllerDataSource, RTSAnalyticsMediaPlayerDataSource>

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit;
- (NSString *)businessUnit;

- (NSUInteger)ongoingFetchCount;

- (BOOL)isFetchPathValidForIndex:(enum SRGILFetchListIndex)index;
- (void)resetFetchPathForIndex:(enum SRGILFetchListIndex)index;

- (void)fetchFlatListOfIndex:(enum SRGILFetchListIndex)index
                onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

- (void)fetchListOfIndex:(enum SRGILFetchListIndex)index
        withPathArgument:(id)arg
               organised:(SRGILModelDataOrganisationType)orgType
              onProgress:(SRGILFetchListDownloadProgressBlock)progressBlock
            onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

- (NSDate *)downloadDateForKey:(NSString *)key;
- (void)refreshDownloadDateForKey:(NSString *)key;

@end
