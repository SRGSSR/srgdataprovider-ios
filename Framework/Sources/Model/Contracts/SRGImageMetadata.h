//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for model objects having an optional image.
 */
@protocol SRGImageMetadata <NSObject>

/**
 *  Return the URL for an image with the specified type and width / height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered.
 *
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in pixels.
 *  @param type      The type of the image. The list of admissible values can be freely defined, usually by a class
 *                   conforming to the `SRGImageMetadata` protocol itself. If no type or an invalid type is specified, 
 *                   the URL of the default image is used.
 *
 *  @discussion The device scale is NOT automatically taken into account. Be sure that the required size in pixels
 *              matches the scale of your device.
 */
- (nullable NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(nullable NSString *)type;

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
