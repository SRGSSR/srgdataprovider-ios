//
//  SRGILDataProvider+MediaPlayer.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 18/05/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider+MediaPlayer.h"
#import "SRGILDataProvider+Private.h"

#import "SRGILErrors.h"
#import "SRGILRequestsManager.h"
#import "SRGILTokenHandler.h"

#import "SRGILComScoreAnalyticsInfos.h"
#import "SRGILStreamSenseAnalyticsInfos.h"
#import "SRGILAnalyticsInfosProtocol.h"

#import "SRGILModel.h"
#import "SRGILModelConstants.h"

#import <libextobjc/EXTScope.h>

static NSString * const comScoreKeyPathPrefix = @"SRGILComScoreAnalyticsInfos.";
static NSString * const streamSenseKeyPathPrefix = @"SRGILStreamSenseAnalyticsInfos.";

@implementation SRGILDataProvider (MediaPlayer)

- (void)setupForMediaPlayer
{
    if (!self.analyticsInfos) {
        self.analyticsInfos = [[NSMutableDictionary alloc] init];
    }
}

#pragma mark - RTSMediaPlayerControllerDataSource

- (void)mediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
      contentURLForIdentifier:(NSString *)identifier
            completionHandler:(void (^)(NSURL *contentURL, NSError *error))completionHandler
{
    NSAssert(identifier, @"Missing identifier to work with.");
    SRGILMedia *existingMedia = self.identifiedMedias[identifier];
    
    @weakify(self)
    
    void (^tokenBlock)(SRGILMedia *) = ^(SRGILMedia *media) {
        if (media.contentURL) {
            [[SRGILTokenHandler sharedHandler] requestTokenForURL:media.contentURL
                                        appendLogicalSegmentation:nil
                                                  completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                      completionHandler(tokenizedURL, error);
                                                  }];
        }
        else {
            NSError *error = [NSError errorWithDomain:SRGILErrorDomain
                                                 code:SRGILErrorVideoNoSourceURL
                                             userInfo:nil];
            
            completionHandler(nil, error);
        }
    };
    
    if (!existingMedia || !existingMedia.contentURL) {
        [self.requestManager requestMediaOfType:SRGILMediaTypeVideo
                                 withIdentifier:identifier
                                completionBlock:^(SRGILMedia *media, NSError *error) {
                                    @strongify(self)
                                
                                    if (error) {
                                        [self.identifiedMedias removeObjectForKey:identifier];
                                        completionHandler(nil, error);
                                    }
                                    else {
                                        self.identifiedMedias[identifier] = media;
                                        [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
                                        tokenBlock(media);
                                    }
                                }];
    }
    else {
        tokenBlock(existingMedia);
    }
}

#pragma mark - Analytics Infos

- (void)prepareAnalyticsInfosForMedia:(SRGILMedia *)media withContentURL:(NSURL *)contentURL
{
    SRGILComScoreAnalyticsInfos *comScoreDataSource = [[SRGILComScoreAnalyticsInfos alloc] initWithMedia:media usingURL:contentURL];
    SRGILStreamSenseAnalyticsInfos *streamSenseDataSource = [[SRGILStreamSenseAnalyticsInfos alloc] initWithMedia:media usingURL:contentURL];
    
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:media.identifier];
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:media.identifier];
    
    self.analyticsInfos[comScoreKeyPath] = comScoreDataSource;
    self.analyticsInfos[streamSenseKeyPath] = streamSenseDataSource;
}

- (SRGILComScoreAnalyticsInfos *)comScoreIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:identifier];
    return self.analyticsInfos[comScoreKeyPath];
}

- (SRGILStreamSenseAnalyticsInfos *)streamSenseIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:identifier];
    return self.analyticsInfos[streamSenseKeyPath];
}

#pragma mark - RTSAnalyticsMediaPlayerDataSource

- (NSDictionary *)comScoreLabelsForAppEnteringForeground
{
    return [SRGILComScoreAnalyticsInfos globalLabelsForAppEnteringForeground];
}

- (NSDictionary *)comScoreReadyToPlayLabelsForIdentifier:(NSString *)identifier
{
    SRGILComScoreAnalyticsInfos *ds = [self comScoreIndividualDataSourceForIdenfifier:identifier];
    return [ds statusLabels];
}

- (NSDictionary *)streamSensePlaylistMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsInfos *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds playlistMetadataForBusinesUnit:self.businessUnit];
}

- (NSDictionary *)streamSenseClipMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsInfos *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds fullLengthClipMetadata];
}

#pragma mark - View Count

- (void)sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:(NSNotification *)notification
{
    RTSMediaPlayerController *player = [notification object];
    RTSMediaPlaybackState oldState = [notification.userInfo[RTSMediaPlayerPreviousPlaybackStateUserInfoKey] integerValue];
    RTSMediaPlaybackState newState = player.playbackState;
    
    if (oldState == RTSMediaPlaybackStatePreparing && newState == RTSMediaPlaybackStateReady) {
        SRGILMedia *media = self.identifiedMedias[player.identifier];
        if (media) {
            NSString *typeName = nil;
            switch ([media type]) {
                case SRGILMediaTypeAudio:
                    typeName = @"audio";
                    break;
                case SRGILMediaTypeVideo:
                    typeName = @"video";
                    break;
                default:
                    NSAssert(false, @"Invalid media type: %d", (int)[media type]);
            }
            if (typeName) {
                [self.requestManager sendViewCountUpdate:player.identifier forMediaTypeName:typeName];
            }
        }
    }
}


@end
