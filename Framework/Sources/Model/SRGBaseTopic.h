//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Abstract base class for topic representation.
 */
@interface SRGBaseTopic : SRGModel <SRGMetadata>

/**
 *  The unique topic identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
