//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubdivision.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Takes a list of subdivisions as input, and sanitizes it so that:
 *    - Segments with incorrect mark-in / out are removed.
 *    - Durations are fixed.
 *    - Subdivisions are guaranteed to be disjoint.
 *    - Blocked content can never be played.
 *    - When possible so that these rules hold, the mark-in of a subdivision is not altered.
 *    - Nested and empty subdivisions are removed.
 *    - Positions are fixed to match the cleaned up list. The initial relative order is preserved. Duplicate positions
 *      will be fixed (the fixed order is undefined, though).
 */
OBJC_EXTERN NSArray<__kindof SRGSubdivision *> *SRGSanitizedSubdivisions(NSArray<SRGSubdivision *> *subdivisions);

NS_ASSUME_NONNULL_END
