//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGResource : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) SRGQuality quality;
@property (nonatomic, readonly) SRGProtocol protocol;
@property (nonatomic, readonly) SRGEncoding encoding;

@end

NS_ASSUME_NONNULL_END
