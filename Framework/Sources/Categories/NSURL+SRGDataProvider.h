//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGTypes.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (SRGUtils)

/**
 *  For a given URL, return the full URL for the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered
 *
 *  @param dimension The dimension (horizontal or vertical)
 *  @param value     The value along the specified dimensions, in points (independent of the device scale)
 */
- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
