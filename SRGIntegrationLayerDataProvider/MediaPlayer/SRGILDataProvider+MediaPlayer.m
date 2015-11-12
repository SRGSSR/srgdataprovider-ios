//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <libextobjc/EXTScope.h>
#import <objc/runtime.h>

#import <SRGMediaPlayer/SRGMediaPlayer.h>
#import <SRGAnalytics/SRGAnalytics.h>

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

#import "NSBundle+SRGILDataProvider.h"

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
    
    void (^playBlock)(SRGILMedia *, NSError *) = ^(SRGILMedia *media, NSError *error) {
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
            
            if (media.contentURL) {
                [self prepareAnalyticsInfosForMedia:media withContentURL:media.contentURL];
                
                [[SRGILTokenHandler sharedHandler] requestTokenForURL:media.contentURL
                                            appendLogicalSegmentation:nil
                                                      completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                          if (error) {
                                                              completionHandler(nil, error);
                                                              return;
                                                          }
                                                          
                                                          if ([media segmentationForURL:media.contentURL] == SRGILPlaylistSegmentationLogical
                                                              && (media.markIn > 0.f) && !media.isLiveStream) {
                                                              NSURLComponents *components = [NSURLComponents componentsWithURL:tokenizedURL resolvingAgainstBaseURL:NO];
                                                              components.query = [components.query stringByAppendingFormat:@"&start=%.0f&end=%.0f", round(media.markIn), round(media.markOut)];
                                                              completionHandler(components.URL, nil);
                                                          }
                                                          else {
                                                              completionHandler(tokenizedURL, nil);
                                                          }
                                                      }];
            }
            else {
                NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                     code:SRGILDataProviderErrorVideoNoSourceURL
                                                 userInfo:nil];
                
                completionHandler(nil, error);
            }
        }
    };
    
    if (!existingMedia || !existingMedia.contentURL) {
        SRGILURN *urn = [SRGILURN URNWithString:urnString];
        
        NSString *errorMessage = nil;
        if (!urn) {
            errorMessage = [NSString stringWithFormat:SRGILDataProviderLocalizedString(@"Unable to create URN from string '%@', which is needed to proceed.", nil), urnString];
        }
        else if (urn.mediaType == SRGILMediaTypeUndefined) {
            errorMessage = [NSString stringWithFormat:SRGILDataProviderLocalizedString(@"Undefined mediaType inferred from URN string '%@'.", nil), urnString];
        }
        
        if (errorMessage) {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidMediaIdentifier
                                             userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            
            completionHandler(nil, error);
        }
        else {
            [self.requestManager requestMediaOfType:urn.mediaType
                                     withIdentifier:urn.identifier
                                    completionBlock:playBlock];
        }
    }
    else {
        playBlock(existingMedia, nil);
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
    
    void (^segmentsAndAnalyticsBlock)(SRGILMedia *) = ^(SRGILMedia *parentMedia) {
        if (parentMedia.contentURL) {
            [self prepareAnalyticsInfosForMedia:parentMedia withContentURL:parentMedia.contentURL];
        }
        
        if (!parentMedia.fullLength || parentMedia.segments.count == 0) {
            completionHandler(nil, nil);
            return;
        }
        
        NSMutableArray *segments = [NSMutableArray array];
        [segments addObject:parentMedia];
        [segments addObjectsFromArray:parentMedia.segments];
        
        completionHandler([segments copy], nil);
    };
    
    // SRGILMedia has been been made conformant to the RTSMediaPlayerSegment protocol (see SRGILVideo+MediaPlayer.h), segments
    // can therefore be displayed as is by the player
    SRGILMedia *media = self.identifiedMedias[urnString];
    if (media.segments) {
        segmentsAndAnalyticsBlock(media);
    }
    else {
        SRGILURN *urn = [SRGILURN URNWithString:urnString];
        
        NSString *errorMessage = nil;
        if (!urn) {
            errorMessage = [NSString stringWithFormat:SRGILDataProviderLocalizedString(@"Unable to create URN from string '%@', which is needed to proceed.", nil), urnString];
        }
        else if (urn.mediaType == SRGILMediaTypeUndefined) {
            errorMessage = [NSString stringWithFormat:SRGILDataProviderLocalizedString(@"Undefined mediaType inferred from URN string '%@'.", nil), urnString];
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
                                        
                                        if (error) {
                                            [self.identifiedMedias removeObjectForKey:urnString];
                                            completionHandler(nil, error);
                                        }
                                        else {
                                            self.identifiedMedias[urnString] = media;
                                            segmentsAndAnalyticsBlock(media);
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
