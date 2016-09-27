//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol for image information association
 */
@protocol SRGImageMetadata <NSObject>

/**
 *  Return the URL for an image with the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered
 *
 *  @param dimension The dimension (horizontal or vertical)
 *  @param value     The value along the specified dimensions, in points (independent of the device scale)
 */
- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

/**
 *  The image title
 */
@property (nonatomic, readonly, copy, nullable) NSString *imageTitle;

/**
 *  The copyright information associated with the image
 */
@property (nonatomic, readonly, copy, nullable) NSString *imageCopyright;

@end

NS_ASSUME_NONNULL_END
