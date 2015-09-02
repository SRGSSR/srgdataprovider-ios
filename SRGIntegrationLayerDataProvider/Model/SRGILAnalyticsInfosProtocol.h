//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILMedia.h"

@protocol SRGILAnalyticsInfos <NSObject>

- (instancetype)initWithMedia:(SRGILMedia *)media usingURL:(NSURL *)playedURL;

@end
