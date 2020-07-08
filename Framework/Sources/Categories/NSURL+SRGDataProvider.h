//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGTypes.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Block signature for image URL overriding.
 *
 *  @param uid      The uid for which content overriding is checked.
 *  @param type     A hint about the type of image for which content overriding is checked (usually 'default').
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in pixels.
 *
 *  @return If a non-`nil` URL is returned, this URL will be used instead of the one received with the object.
 */
typedef NSURL * _Nullable (^SRGDataProviderURLOverridingBlock)(NSString *uid, NSString *type, SRGImageDimension dimension, CGFloat value);

/**
 *  Data provider extensions to `NSURL`.
 */
@interface NSURL (SRGDataProvider)

/**
 *  For a given URL, return the full URL for the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered.
 *
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in pixels.
 *  @param type      An optional type provided as a hint for content overriding. Set to `nil` for default images.
 *                   If no image is found for the specified type, no override will be applied.
 *
 *  @discussion The device scale is NOT automatically taken into account. Be sure that the required size in pixels
 *              matches the scale of your device.
 */
- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type;

@end

NS_ASSUME_NONNULL_END
