//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGSubtitle : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) SRGSubtitleFormat format;
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
