//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSocialCount.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGLike : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly) SRGMediaType mediaType;
@property (nonatomic, readonly, copy) NSString *vendor;
@property (nonatomic, readonly, copy) NSString *URN;

@property (nonatomic, readonly) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
