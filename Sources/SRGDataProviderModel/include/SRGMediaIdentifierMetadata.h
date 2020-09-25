//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGIdentifierMetadata.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for media identification.
 */
@protocol SRGMediaIdentifierMetadata <SRGIdentifierMetadata>

/**
 *  The media type.
 */
@property (nonatomic, readonly) SRGMediaType mediaType;

@end

NS_ASSUME_NONNULL_END
