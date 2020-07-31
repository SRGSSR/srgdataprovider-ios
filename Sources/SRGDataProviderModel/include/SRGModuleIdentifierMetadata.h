//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGIdentifierMetadata.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for module identification.
 */
@protocol SRGModuleIdentifierMetadata <SRGIdentifierMetadata>

/**
 *  The module type.
 */
@property (nonatomic, readonly) SRGModuleType moduleType;

@end

NS_ASSUME_NONNULL_END
