//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaRepresentationMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A section is a logical media subdivision. It can correspond to an actual media (@see `SRGChapter`) or to a subset
 *  of a media (logical segmentation).
 */
@interface SRGSegment : SRGModel <SRGMediaRepresentationMetadata>

@end

NS_ASSUME_NONNULL_END
