//
//  SRGILMediaPlayerDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSMediaPlayer/RTSMediaPlayer.h>

@interface SRGILMediaPlayerControllerDataSource : NSObject <RTSMediaPlayerControllerDataSource>

- (instancetype)initWithBusinessUnit:(NSString *)businessUnit;
- (NSString *)businessUnit;

- (BOOL)isHDURL:(NSURL *)URL forIdentifier:(NSString *)identifier;

@end
