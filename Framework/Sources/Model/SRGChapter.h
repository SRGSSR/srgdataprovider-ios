//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"
#import "SRGScheduledLivestreamMetadata.h"
#import "SRGSegment.h"
#import "SRGSubdivision.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Chapter (unit of media playback characterized by a URL to be played).
 */
@interface SRGChapter : SRGSubdivision <SRGScheduledLivestreamMetadata>

/**
 *  The list of available resources.
 *
 *  @discussion The list contains the raw resource list available for a chapter. Some resources might not be supported 
 *              on a platform or device, though (e.g. HDS resources). The `Resources` category below provides methods
 *              to retrieve resources which can be actually played on the device or platform.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGResource *> *resources;

/**
 *  The list of segments associated with the chapter.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSegment *> *segments;

@end

@interface SRGChapter (Resources)

/**
 *  Return the list of supported streaming methods (from the most to the least recommended method).
 */
+ (NSArray<NSNumber *> *)supportedStreamingMethods;

/**
 *  Return the set of resources which can be actually played on the device or platform.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGResource *> *playableResources;

/**
 *  The recommended streaming method to use. Might return `SRGStreamingMethodNone` if no good match is found.
 */
@property (nonatomic, readonly) SRGStreamingMethod recommendedStreamingMethod;

/**
 *  Return resources matching the specified streaming method, from the highest to the lowest available qualities.
 */
- (nullable NSArray<SRGResource *> *)resourcesForStreamingMethod:(SRGStreamingMethod)streamingMethod;

@end

NS_ASSUME_NONNULL_END
