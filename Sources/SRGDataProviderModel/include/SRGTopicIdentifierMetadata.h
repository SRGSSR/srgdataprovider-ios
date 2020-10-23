//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGIdentifierMetadata.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for topic identification.
 */
@protocol SRGTopicIdentifierMetadata <SRGIdentifierMetadata>

/**
 *  The topic transmission.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

@end

NS_ASSUME_NONNULL_END
