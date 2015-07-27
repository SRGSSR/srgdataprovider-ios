//
//  SRGILDataProvider+MediaPlayer.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 18/05/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDataProvider+MediaPlayer.h"
#import "SRGILDataProvider+Private.h"
#import "SRGILDataProviderConstants.h"

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
    
    if (!self.analyticsInfos) {
        self.analyticsInfos = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:)
                                                     name:RTSMediaPlayerPlaybackStateDidChangeNotification
                                                   object:nil];
    }
    
    SRGILMedia *existingMedia = self.identifiedMedias[urnString];
    
    void (^tokenBlock)(SRGILMedia *) = ^(SRGILMedia *media) {
        if (media.contentURL) {
            [[SRGILTokenHandler sharedHandler] requestTokenForURL:media.contentURL
                                        appendLogicalSegmentation:nil
                                                  completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                      completionHandler(tokenizedURL, error);
                                                  }];
        }
        else {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorVideoNoSourceURL
                                             userInfo:nil];
            
            completionHandler(nil, error);
        }
    };
    
    if (!existingMedia || !existingMedia.contentURL) {
        SRGILURN *urn = [SRGILURN URNWithString:urnString];
        
        NSString *errorMessage = nil;
        if (!urn) {
            errorMessage = [NSString stringWithFormat:NSLocalizedString(@"Unable to create URN from string '%@', which is needed to proceed.", nil), urnString];
        }
        else if (urn.mediaType == SRGILMediaTypeUndefined) {
            errorMessage = [NSString stringWithFormat:NSLocalizedString(@"Undefined mediaType inferred from URN string '%@'.", nil), urnString];
        }
        
        if (errorMessage) {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidMediaIdentifier
                                             userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            
            completionHandler(nil, error);
        }
        else {
            @weakify(self)
            [self.requestManager requestMediaOfType:urn.mediaType
                                     withIdentifier:urn.identifier
                                    completionBlock:^(SRGILMedia *media, NSError *error) {
                                        @strongify(self)
                                        
                                        if (!error && media.blocked) {
                                            error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                                        code:SRGILDataProviderErrorVideoNoSourceURL
                                                                    userInfo:@{NSLocalizedDescriptionKey: SRGILMediaBlockingReasonMessageForReason(media.blockingReason)}];
                                        }
                                    
                                        if (error) {
                                            [self.identifiedMedias removeObjectForKey:urnString];
                                            completionHandler(nil, error);
                                        }
                                        else {
                                            self.identifiedMedias[urnString] = media;
                                            [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
                                            tokenBlock(media);
                                        }
                                    }];
        }
    }
    else {
        [self prepareAnalyticsInfosForMedia:existingMedia withContentURL:existingMedia.contentURL];
        tokenBlock(existingMedia);
    }
}

#pragma mark - RTSMediaSegmentsDataSource

- (void)segmentsController:(RTSMediaSegmentsController *)controller
     segmentsForIdentifier:(NSString *)urnString
     withCompletionHandler:(RTSMediaSegmentsCompletionHandler)completionHandler;
{
    if (!self.analyticsInfos) {
        self.analyticsInfos = [[NSMutableDictionary alloc] init];
    }
    
    // SRGILMedia has been been made conformant to the RTSMediaPlayerSegment protocol (see SRGILVideo+MediaPlayer.h), segments
    // can therefore be displayed as is by the player
    SRGILMedia *media = self.identifiedMedias[urnString];
    if (media.segments) {
        [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
        NSArray *segments = (media.isFullLength) ? media.segments : nil;
        completionHandler((id<RTSMediaSegment>)media, segments, nil);
    }
    else {
        SRGILURN *urn = [SRGILURN URNWithString:urnString];
        
        NSString *errorMessage = nil;
        if (!urn) {
            errorMessage = [NSString stringWithFormat:NSLocalizedString(@"Unable to create URN from string '%@', which is needed to proceed.", nil), urnString];
        }
        else if (urn.mediaType == SRGILMediaTypeUndefined) {
            errorMessage = [NSString stringWithFormat:NSLocalizedString(@"Undefined mediaType inferred from URN string '%@'.", nil), urnString];
        }
        
        if (errorMessage) {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidMediaIdentifier
                                             userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            
            completionHandler(nil, nil, error);
        }
        else {
            @weakify(self)
            [self.requestManager requestMediaOfType:urn.mediaType
                                     withIdentifier:urn.identifier
                                    completionBlock:^(SRGILMedia *media, NSError *error) {
                                        @strongify(self)
                                        
                                        if (error) {
                                            [self.identifiedMedias removeObjectForKey:urnString];
                                            completionHandler(nil, nil, error);
                                        }
                                        else {
                                            self.identifiedMedias[urnString] = media;
                                            [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
                                            NSArray *segments = (media.isFullLength) ? media.segments : nil;
                                            completionHandler((id<RTSMediaSegment>)media, segments, error);
                                        }
                                    }];
        }
    }
}

#pragma mark - Analytics Infos

- (void)prepareAnalyticsInfosForMedia:(SRGILMedia *)media withContentURL:(NSURL *)contentURL
{
    NSParameterAssert(media);
    NSParameterAssert(contentURL);
    NSParameterAssert(media.urnString);
    
    // Do not check for existing sources. Allow to override the sources with a freshly-(re)downloaded media.
    
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:media.urnString];
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:media.urnString];
 
    SRGILComScoreAnalyticsInfos *comScoreDataSource = [[SRGILComScoreAnalyticsInfos alloc] initWithMedia:media usingURL:contentURL];
    SRGILStreamSenseAnalyticsInfos *streamSenseDataSource = [[SRGILStreamSenseAnalyticsInfos alloc] initWithMedia:media usingURL:contentURL];

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
        SRGILURN *urn = [SRGILURN URNWithString:player.identifier];
        NSAssert(urn, @"Unable to create URN from identifier, which is needed to proceed.");
        NSAssert(urn.mediaType != SRGILMediaTypeUndefined, @"Undefined mediaType inferred from URN.");

        NSString *typeName = nil;
        switch (urn.mediaType) {
            case SRGILMediaTypeAudio:
                typeName = @"audio";
                break;
            case SRGILMediaTypeVideo:
                typeName = @"video";
                break;
            default:
                NSAssert(false, @"Invalid media type: %d", (int)urn.mediaType);
                break;
        }
        
        if (typeName) {
            [self.requestManager sendViewCountUpdate:urn.identifier forMediaTypeName:typeName];
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
