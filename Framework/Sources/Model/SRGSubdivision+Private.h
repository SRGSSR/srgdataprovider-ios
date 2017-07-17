//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubdivision.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This function takes a list of subdivisions as input, and sanitizes it so that:
 *    - Invalid segments are removed (zero duration or mark-in larger than mark-out)
 *    - Subdivisions are guaranteed to be disjoint.
 *    - Blocked content can never be played.
 *    - Segments might be repeated several times when cut by another segment.
 *    - Positions are fixed to match the cleaned up list.
 */
OBJC_EXTERN NSArray<__kindof SRGSubdivision *> *SRGSanitizedSubdivisions(NSArray<SRGSubdivision *> *subdivisions);

NS_ASSUME_NONNULL_END
