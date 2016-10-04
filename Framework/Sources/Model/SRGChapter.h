//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"
#import "SRGSegment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Chapter (unit of media playback characterized by a URL to be played)
 */
@interface SRGChapter : SRGSegment

/**
 *  The list of available resources
 */
@property (nonatomic, readonly, nullable) NSArray<SRGResource *> *resources;

/**
 *  The list of segments associated with the chapter
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSegment *> *segments;

@end

@interface SRGChapter (Resources)

/**
 *  Return resources matching the specified protocol, from the highest to the lowest available qualities
 */
- (nullable NSArray<SRGResource *> *)resourcesForProtocol:(SRGProtocol)protocol;

@end

NS_ASSUME_NONNULL_END
