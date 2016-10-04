//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Measure associated with a social network or popularity service
 */
@interface SRGSocialCount : MTLModel <MTLJSONSerializing>

/**
 *  The type of service
 */
@property (nonatomic, readonly) SRGSocialCountType type;

/**
 *  The associated count (likes, views, etc. depending on the service)
 */
@property (nonatomic, readonly) NSInteger value;

@end

NS_ASSUME_NONNULL_END
