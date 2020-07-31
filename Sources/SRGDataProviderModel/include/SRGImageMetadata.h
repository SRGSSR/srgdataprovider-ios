//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

@import CoreGraphics;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

// Supported image types
typedef NSString * SRGImageType NS_TYPED_ENUM;

OBJC_EXPORT SRGImageType const SRGImageTypeDefault;          // Default image.

/**
 *  Common protocol for model objects having an image.
 */
@protocol SRGImage <NSObject>

/**
 *  Return the URL for an image with the specified type and width / height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered.
 *
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in pixels.
 *  @param type      The type of the image. The list of admissible values, if any, is publicly made available through dedicated
 *                   constants declared by classes conforming to `SRGImageMetadata`. For a default image, use `SRGImageTypeDefault`.
 *                   If an invalid type is specified, the default image is used.
 *
 *  @discussion The device scale is NOT automatically taken into account. Be sure that the required size in pixels
 *              matches the scale of your device.
 */
- (nullable NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type;

@end

/**
 *  Common protocol for model objects having an image and associated information.
 */
@protocol SRGImageMetadata <SRGImage>

/**
 *  The image title.
 */
@property (nonatomic, readonly, copy, nullable) NSString *imageTitle;

/**
 *  The copyright information associated with the image.
 */
@property (nonatomic, readonly, copy, nullable) NSString *imageCopyright;

@end

NS_ASSUME_NONNULL_END
