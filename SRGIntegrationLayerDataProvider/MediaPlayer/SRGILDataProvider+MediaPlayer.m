//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#import <libextobjc/EXTScope.h>
#import <objc/runtime.h>

#import "SRGILDataProvider+MediaPlayer.h"
#import "SRGILDataProvider+Private.h"
#import "SRGILDataProviderConstants.h"

#import "SRGILRequestsManager.h"
#import "SRGILTokenHandler.h"

#import "SRGILComScoreAnalyticsInfos.h"
#import "SRGILStreamSenseAnalyticsInfos.h"
#import "SRGILAnalyticsInfosProtocol.h"

#import "SRGILModel.h"
#import "SRGILModelConstants.h"

#import "NSBundle+SRGILDataProvider.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

static void *kAnalyticsInfosAssociatedObjectKey = &kAnalyticsInfosAssociatedObjectKey;
static void *kRegisteredAsObserverKey = &kRegisteredAsObserverKey;

static NSString * const comScoreKeyPathPrefix = @"SRGILComScoreAnalyticsInfos.";
static NSString * const streamSenseKeyPathPrefix = @"SRGILStreamSenseAnalyticsInfos.";

@interface SRGILDataProvider (MediaPlayerPrivate)
@property(nonatomic, strong) NSMutableDictionary *analyticsInfos;
@property(nonatomic, getter=isRegisteredAsObserver) BOOL registeredAsObserver;
@end

@implementation SRGILDataProvider (MediaPlayer)

#pragma mark - RTSMediaPlayerControllerDataSource

- (void)mediaPlayerController:(RTSMediaPlayerController *)mediaPlayerController
      contentURLForIdentifier:(NSString *)urnString
            completionHandler:(void (^)(NSURL *contentURL, NSError *error))completionHandler
{
    NSAssert(urnString, @"Missing identifier to work with.");
    
    // Register once. Since we are in a category, we cannot override initialization and deallocation methods (well, we could
    // swizzle them...). Instead, lazily register. The -[SRGILDataProvider dealloc] method has been implemented to properly
    // unregisters from the notification center
    if (!self.registeredAsObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendViewCountMetaDataUponMediaPlayerPlaybackStateChange:)
                                                     name:RTSMediaPlayerPlaybackStateDidChangeNotification
                                                   object:nil];
        self.registeredAsObserver = YES;
    }
    
    SRGILMedia *existingMedia = self.identifiedMedias[urnString];
    
    void (^playBlock)(SRGILMedia *, NSError *) = ^(SRGILMedia *media, NSError *error) {
        if (!error && media.isBlocked) {
            error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                        code:SRGILDataProviderErrorCodeUnavailable
                                    userInfo:@{ NSLocalizedDescriptionKey : SRGILMediaBlockingReasonMessageForReason(media.blockingReason) }];
        }
        
        if (error) {
            [self.identifiedMedias removeObjectForKey:urnString];
            completionHandler(nil, error);
        }
        else {
            self.identifiedMedias[urnString] = media;
            
            if (media.defaultContentURL) {
                DDLogDebug(@"Found default content URL %@ for identifier %@", media.defaultContentURL, urnString);
                [self prepareAnalyticsInfosForMedia:media withContentURL:media.defaultContentURL];
                
                [[SRGILTokenHandler sharedHandler] requestTokenForURL:media.defaultContentURL
                                                      completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                          if (error) {
                                                              completionHandler(nil, error);
                                                              return;
                                                          }
                                                          
                                                          if ([media segmentationForURL:media.defaultContentURL] == SRGILPlaylistSegmentationLogical
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
                                                     code:SRGILDataProviderErrorCodeUnavailable
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The media cannot be played.", nil) }];
                completionHandler(nil, error);
            }
        }
    };
    
    if (existingMedia && existingMedia.defaultContentURL) {
        playBlock(existingMedia, nil);
    }
    else {
        SRGILURN *urn = [SRGILURN URNWithString:urnString];
        if (!urn || urn.mediaType == SRGILMediaTypeUndefined) {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidData
                                             userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The media cannot be played.", nil) }];
            completionHandler(nil, error);
            return;
        }
        
        [self.requestManager requestMediaWithURN:urn completionBlock:playBlock];
    }
}

#pragma mark - RTSMediaSegmentsDataSource

- (void)segmentsController:(RTSMediaSegmentsController *)controller
     segmentsForIdentifier:(NSString *)urnString
     withCompletionHandler:(RTSMediaSegmentsCompletionHandler)completionHandler;
{
    void (^segmentsAndAnalyticsBlock)(SRGILMedia *) = ^(SRGILMedia *parentMedia) {
        if (parentMedia.defaultContentURL) {
            [self prepareAnalyticsInfosForMedia:parentMedia withContentURL:parentMedia.defaultContentURL];
        }
        
        if (!parentMedia.fullLength || parentMedia.segments.count == 0) {
            SRGILAsset * asset = parentMedia.assetSet.assets.firstObject;
            if (![asset fullLengthMedia] && ([asset mediaSegments].count > 1)) // Asset with segments but without a full length
            {
                completionHandler(asset.mediaSegments, nil);
            }
            else
            {
                completionHandler(nil, nil);
            }
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
        if (!urn || urn.mediaType == SRGILMediaTypeUndefined) {
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidData
                                             userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The media cannot be played.", nil) }];
            completionHandler(nil, error);
            return;
        }
        
        @weakify(self)
        [self.requestManager requestMediaWithURN:urn
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

#pragma mark - Analytics Infos

- (void)prepareAnalyticsInfosForMedia:(SRGILMedia *)media withContentURL:(NSURL *)contentURL
{
    NSParameterAssert(media);
    NSParameterAssert(contentURL);
    NSParameterAssert(media.urnString);
    
    if (!self.analyticsInfos) {
        self.analyticsInfos = [[NSMutableDictionary alloc] init];
    }
    
    // Do not check for existing sources. Allow to override the sources with a freshly-(re)downloaded media.
    
    NSString *comScoreKeyPath = [comScoreKeyPathPrefix stringByAppendingString:media.urnString];
    NSString *streamSenseKeyPath = [streamSenseKeyPathPrefix stringByAppendingString:media.urnString];
    
    SRGILComScoreAnalyticsInfos *comScoreDataSource = [[SRGILComScoreAnalyticsInfos alloc] initWithMedia:media usingURL:contentURL];
    SRGILStreamSenseAnalyticsInfos *streamSenseDataSource = [[SRGILStreamSenseAnalyticsInfos alloc] initWithMedia:media usingURL:contentURL];
    
    self.analyticsInfos[comScoreKeyPath] = comScoreDataSource;
    self.analyticsInfos[streamSenseKeyPath] = streamSenseDataSource;
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
        if (urn && urn.mediaType != SRGILMediaTypeUndefined) {
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

- (BOOL)isRegisteredAsObserver
{
    return [objc_getAssociatedObject(self, kRegisteredAsObserverKey) boolValue];
}

- (void)setRegisteredAsObserver:(BOOL)registeredAsObserver
{
    objc_setAssociatedObject(self, kRegisteredAsObserverKey, @(registeredAsObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
