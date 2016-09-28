//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Topic (e.g. sports, kids, etc.)
 */
@interface SRGTopic : MTLModel <SRGMetadata, MTLJSONSerializing>

/**
 *  The unique topic identifier
 */
@property (nonatomic, readonly, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
