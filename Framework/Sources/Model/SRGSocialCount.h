//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGSocialCount : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) SRGSocialCountType type;
@property (nonatomic, readonly) NSInteger value;

@end

NS_ASSUME_NONNULL_END
