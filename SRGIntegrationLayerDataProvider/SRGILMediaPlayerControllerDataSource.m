//
//  SRGILMediaPlayerDataProvider.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILMediaPlayerControllerDataSource.h"
#import "SRGILRequestsManager.h"
#import "SRGILTokenHandler.h"

#import "SRGILComScoreAnalyticsInfos.h"
#import "SRGILStreamSenseAnalyticsInfos.h"
#import "SRGILAnalyticsInfosProtocol.h"

#import "SRGILModel.h"
#import "SRGILMedia+Private.h"

#import <libextobjc/EXTScope.h>

static NSString * const comScoreKeyPathPrefix = @"SRGILComScoreAnalyticsInfos.";
static NSString * const streamSenseKeyPathPrefix = @"SRGILStreamSenseAnalyticsInfos.";

@interface SRGILMediaPlayerControllerDataSource () {
    NSMutableDictionary *_identifiedDataSources;
    NSMutableDictionary *_analyticsInfos;
}
@property(nonatomic, strong) SRGILRequestsManager *requestManager;
@end

@implementation SRGILMediaPlayerControllerDataSource

+ (NSString *)comScoreVirtualSite:(NSString *)businessUnit
{
    return [NSString stringWithFormat:@"%@-player-ios-v", [businessUnit lowercaseString]];
}

+ (NSString *)streamSenseVirtualSite:(NSString *)businessUnit
{
    return [NSString stringWithFormat:@"%@-v", [businessUnit lowercaseString]];
}

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit
{
    self = [super init];
    if (self) {
        _identifiedDataSources = [[NSMutableDictionary alloc] init];
        _analyticsInfos = [[NSMutableDictionary alloc] init];
        _requestManager = [[SRGILRequestsManager alloc] initWithBusinessUnit:businessUnit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:)
                                                     name:RTSMediaPlayerPlaybackStateDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (NSString *)businessUnit
{
    return _requestManager.businessUnit;
}

- (void)mediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
      contentURLForIdentifier:(NSString *)identifier
            completionHandler:(void (^)(NSURL *contentURL, NSError *error))completionHandler
{
    NSAssert(identifier, @"Missing identifier to work with.");
    SRGILMedia *existingMedia = _identifiedDataSources[identifier];
    
    @weakify(self)
    
    void (^tokenBlock)(SRGILMedia *) = ^(SRGILMedia *media) {
        @strongify(self)
        NSURL *contentURL = [self contentURLForMedia:media];
        [[SRGILTokenHandler sharedHandler] requestTokenForURL:contentURL
                                    appendLogicalSegmentation:nil
                                              completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                  completionHandler(tokenizedURL, error);
                                              }];
    };
    
    if (existingMedia) {
        tokenBlock(existingMedia);
    }
    else {
        [_requestManager requestMediaOfType:SRGILMediaTypeVideo
                             withIdentifier:identifier
                            completionBlock:^(SRGILMedia *media, NSError *error) {
                                _identifiedDataSources[identifier] = media;
                                [self prepareAnalyticsInfosForMedia:media];
                                tokenBlock(media);
                            }];
    }
}

- (NSURL *)contentURLForMedia:(SRGILMedia *)media
{
    if ([media isKindOfClass:[SRGILVideo class]]) {
        NSURL *contentURL = nil;
        
        BOOL takeHDVideo = [[NSUserDefaults standardUserDefaults] boolForKey:SRGILVideoUseHighQualityOverCellularNetworkKey];
        BOOL usingTrueWIFINetwork = [SRGILRequestsManager isUsingWIFI] && ![SRGILRequestsManager isUsingSwisscomWIFI];
        
        if (usingTrueWIFINetwork || takeHDVideo) {
            // We are on True WIFI (non-Swisscom) or the HD quality switch is ON.
            contentURL = (media.HDHLSURL) ? [media.HDHLSURL copy] : [media.SDHLSURL copy];
        }
        else {
            // We are not on WIFI and switch is OFF. YES, business decision: we play HD as backup if we don't have SD.
            contentURL = (media.SDHLSURL) ? [media.SDHLSURL copy] : [media.HDHLSURL copy];
        }
        return contentURL;
    }
    else if ([media isKindOfClass:[SRGILAudio class]]) {
        return media.MQHLSURL ? media.MQHLSURL : media.MQHTTPURL;
    }
    return nil;
}

- (BOOL)isHDURL:(NSURL *)URL forIdentifier:(NSString *)identifier
{
    SRGILVideo *video = _identifiedDataSources[identifier];
    if (!video) {
        return NO;
    }
    return [URL isEqual:video.HDHLSURL];
}

- (void)sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:(NSNotification *)notification
{
    RTSMediaPlayerController *player = [notification object];
    RTSMediaPlaybackState oldState = [notification.userInfo[RTSMediaPlayerPreviousPlaybackStateUserInfoKey] integerValue];
    RTSMediaPlaybackState newState = player.playbackState;

    if (oldState == RTSMediaPlaybackStatePreparing && newState == RTSMediaPlaybackStateReady) {
        SRGILMedia *media = _identifiedDataSources[player.identifier];
        if (media) {
            NSString *typeName = nil;
            switch ([[media class] type]) {
                case SRGILMediaTypeAudio:
                    typeName = @"audio";
                    break;
                case SRGILMediaTypeVideo:
                    typeName = @"video";
                    break;
                default:
                    NSAssert(false, @"Invalid media type: %d", (int)[[media class] type]);
            }
            if (typeName) {
                [_requestManager sendViewCountUpdate:player.identifier forMediaTypeName:typeName];
            }
        }
    }
}


#pragma mark - Analytics Infos 

- (void)prepareAnalyticsInfosForMedia:(SRGILMedia *)media
{
    SRGILComScoreAnalyticsInfos *comScoreDataSource = [[SRGILComScoreAnalyticsInfos alloc] initWithMedia:media];
    SRGILStreamSenseAnalyticsInfos *streamSenseDataSource = [[SRGILStreamSenseAnalyticsInfos alloc] initWithMedia:media];
    
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:media.identifier];
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:media.identifier];
    
    _analyticsInfos[comScoreKeyPath] = comScoreDataSource;
    _analyticsInfos[streamSenseKeyPath] = streamSenseDataSource;
}

- (SRGILComScoreAnalyticsInfos *)comScoreIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:identifier];
    return _analyticsInfos[comScoreKeyPath];
}

- (SRGILStreamSenseAnalyticsInfos *)streamSenseIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:identifier];
    return _analyticsInfos[streamSenseKeyPath];
}

#pragma mark - RTSAnalyticsDataSource

- (RTSAnalyticsMediaMode)mediaModeForIdentifier:(NSString *)identifier
{
    SRGILComScoreAnalyticsInfos *ds = [self comScoreIndividualDataSourceForIdenfifier:identifier];
    return ds.mediaMode;
}

- (NSDictionary *)comScoreLabelsForAppEnteringForeground
{
    NSMutableDictionary *labels = [NSMutableDictionary dictionary];
    
    NSString *category = @"APP";
    NSString *srg_n1   = @"event";
    NSString *title    = @"comingToForeground";
    
    [labels setObject:category forKey:@"category"];
    [labels setObject:srg_n1   forKey:@"srg_n1"];
    [labels setObject:title    forKey:@"srg_title"];
    
    [labels setObject:[NSString stringWithFormat:@"Player.%@.%@", category, title] forKey:@"name"];
    
    return [labels copy];
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

- (NSDictionary *)streamSenseFullLengthClipMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsInfos *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds fullLengthClipMetadata];
}

@end
