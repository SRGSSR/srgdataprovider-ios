//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

@class SRGMedia;

NS_ASSUME_NONNULL_BEGIN

@interface SRGEpisode : MTLModel <SRGImageMetadata, SRGMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, nullable) NSArray<SRGMedia *> *medias;

@end

NS_ASSUME_NONNULL_END
