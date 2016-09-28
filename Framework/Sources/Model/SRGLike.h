//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaIdentifierMetadata.h"
#import "SRGSocialCount.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Information returned as the result of a request increasing social media counters
 */
@interface SRGLike : MTLModel <SRGMediaIdentifierMetadata, MTLJSONSerializing>

/**
 *  The updated social media and popularity information
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
