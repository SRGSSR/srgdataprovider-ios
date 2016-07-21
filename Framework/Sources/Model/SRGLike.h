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

@interface SRGLike : MTLModel <SRGMediaIdentifierMetadata, MTLJSONSerializing>

@property (nonatomic, readonly) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
