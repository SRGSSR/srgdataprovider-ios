//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"
#import "SRGMediaParentMetadata.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A media (audio or video). This is a lightweight representation (which does not contain the URLs to be played,
 *  most notably). For complete playack context information, an `SRGMediaComposition` must be requested.
 */
@interface SRGMedia : MTLModel <SRGMediaMetadata, SRGMediaParentMetadata, MTLJSONSerializing>

@end

NS_ASSUME_NONNULL_END
