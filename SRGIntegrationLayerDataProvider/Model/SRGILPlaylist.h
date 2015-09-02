//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"

@interface SRGILPlaylist : SRGILModelObject

@property(nonatomic, assign, readonly) SRGILPlaylistProtocol protocol;
@property(nonatomic, assign, readonly) SRGILPlaylistSegmentation segmentation;

- (NSURL *)URLForQuality:(SRGILPlaylistURLQuality)quality;

@end
