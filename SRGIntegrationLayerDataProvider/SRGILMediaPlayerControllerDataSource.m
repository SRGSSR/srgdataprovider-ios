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

#import "SRGILModel.h"
#import "SRGILMedia+Private.h"

@interface SRGILMediaPlayerControllerDataSource () {
    NSMutableDictionary *_identifiedDataSources;
}
@property(nonatomic, strong) SRGILRequestsManager *requestManager;
@end

@implementation SRGILMediaPlayerControllerDataSource

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit
{
    self = [super init];
    if (self) {
        _identifiedDataSources = [[NSMutableDictionary alloc] init];
        _requestManager = [[SRGILRequestsManager alloc] initWithBusinessUnit:businessUnit];
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
    SRGILVideo *video = _identifiedDataSources[identifier];
    
    if (video) {
        NSURL *contentURL = [self contentURLForMedia:video];
        [[SRGILTokenHandler sharedHandler] requestTokenForURL:contentURL
                                  appendLogicalSegmentation:nil
                                            completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                completionHandler(tokenizedURL, error);
                                            }];
    }
    else {
        [_requestManager requestMediaOfType:SRGILMediaTypeVideo
                             withIdentifier:identifier
                            completionBlock:^(SRGILMedia *media, NSError *error) {
                                _identifiedDataSources[identifier] = media;
                                NSURL *contentURL = [self contentURLForMedia:video];
                                [[SRGILTokenHandler sharedHandler] requestTokenForURL:contentURL
                                                          appendLogicalSegmentation:nil
                                                                    completionBlock:^(NSURL *tokenizedURL, NSError *error) {
                                                                        completionHandler(tokenizedURL, error);
                                                                    }];
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

@end
