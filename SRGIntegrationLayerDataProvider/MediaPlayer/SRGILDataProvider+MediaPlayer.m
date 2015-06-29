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
#import <objc/runtime.h>

static void *kAnalyticsInfosAssociatedObjectKey = &kAnalyticsInfosAssociatedObjectKey;

static NSString * const comScoreKeyPathPrefix = @"SRGILComScoreAnalyticsInfos.";
static NSString * const streamSenseKeyPathPrefix = @"SRGILStreamSenseAnalyticsInfos.";

@interface SRGILDataProvider (MediaPlayerPrivate)
@property(nonatomic, strong) NSMutableDictionary *analyticsInfos;
@end

@implementation SRGILDataProvider (MediaPlayer)

#pragma mark - RTSMediaPlayerControllerDataSource

- (void)mediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
      contentURLForIdentifier:(NSString *)urnString
            completionHandler:(void (^)(NSURL *contentURL, NSError *error))completionHandler
{
    NSAssert(urnString, @"Missing identifier to work with.");
    
    SRGILURN *urn = [SRGILURN URNWithString:urnString];
    NSAssert(urn, @"Unable to create URN from identifier, which is needed to proceed.");
    NSAssert(urn.mediaType != SRGILMediaTypeUndefined, @"Undefined mediaType inferred from URN.");
    
    if (!self.analyticsInfos) {
        self.analyticsInfos = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:)
                                                     name:RTSMediaPlayerPlaybackStateDidChangeNotification
                                                   object:nil];
    }
    
    SRGILMedia *existingMedia = self.identifiedMedias[urn.identifier];
    
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
        [self.requestManager requestMediaOfType:urn.mediaType
                                 withIdentifier:urn.identifier
                                completionBlock:^(SRGILMedia *media, NSError *error) {
                                    @strongify(self)
                                
                                    if (error) {
                                        [self.identifiedMedias removeObjectForKey:urn.identifier];
                                        completionHandler(nil, error);
                                    }
                                    else {
                                        self.identifiedMedias[urn.identifier] = media;
                                        [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
                                        tokenBlock(media);
                                    }
                                }];
    }
    else {
        tokenBlock(existingMedia);
    }
}

#pragma mark - RTSMediaSegmentsDataSource

- (void)segmentsController:(RTSMediaSegmentsController *)controller
     segmentsForIdentifier:(NSString *)urnString
     withCompletionHandler:(RTSMediaSegmentsCompletionHandler)completionHandler;
{
    SRGILURN *urn = [SRGILURN URNWithString:urnString];
    NSAssert(urn, @"Unable to create URN from identifier, which is needed to proceed.");
    NSAssert(urn.mediaType != SRGILMediaTypeUndefined, @"Undefined mediaType inferred from URN.");

    // SRGILMedia has been been made conformant to the RTSMediaPlayerSegment protocol (see SRGILVideo+MediaPlayer.h), segments
    // can therefore be displayed as is by the player
    SRGILMedia *media = self.identifiedMedias[urn.identifier];
    if (media) {
        completionHandler((id<RTSMediaSegment>)media, media.segments, nil);
    }
    else {
        @weakify(self)
        [self.requestManager requestMediaOfType:SRGILMediaTypeVideo
                                 withIdentifier:urn.identifier
                                completionBlock:^(SRGILMedia *media, NSError *error) {
                                    @strongify(self)
                                    
                                    if (error) {
                                        [self.identifiedMedias removeObjectForKey:urn.identifier];
                                        completionHandler(nil, nil, error);
                                    }
                                    else {
                                        self.identifiedMedias[urn.identifier] = media;
                                        [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
                                        completionHandler((id<RTSMediaSegment>)media, media.segments, error);
                                    }
                                }];
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

- (NSDictionary *)streamSenseClipMetadataForIdentifier:(NSString *)identifier withSegment:(id<RTSMediaSegment>)segment
{
    SRGILStreamSenseAnalyticsInfos *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    NSMutableDictionary *medataData = [[ds fullLengthClipMetadata] mutableCopy];
    if (segment) {
        [medataData addEntriesFromDictionary:[ds segmentClipMetadataForMedia:segment]];
    }
    return [medataData copy];
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

@implementation SRGILDataProvider (MediaPlayerPrivate)

- (NSMutableDictionary *)analyticsInfos
{
    return objc_getAssociatedObject(self, kAnalyticsInfosAssociatedObjectKey);
}

- (void)setAnalyticsInfos:(NSMutableDictionary *)analyticsInfos
{
    objc_setAssociatedObject(self, kAnalyticsInfosAssociatedObjectKey, analyticsInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
