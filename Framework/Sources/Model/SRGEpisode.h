//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContracts.h"
#import "SRGMedia.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGEpisode : MTLModel <SRGMetaData, SRGImage, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;

@property (nonatomic, readonly, nullable) NSArray<SRGMedia *> *medias;

@end

NS_ASSUME_NONNULL_END
