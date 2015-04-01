//
//  SRGILPlaylist.h
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 20/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"

@interface SRGILPlaylist : SRGILModelObject

@property(nonatomic, assign, readonly) SRGILPlaylistProtocol protocol;
@property(nonatomic, assign, readonly) SRGILPlaylistSegmentation segmentation;

- (NSURL *)URLForQuality:(SRGILPlaylistURLQuality)quality;

@end
