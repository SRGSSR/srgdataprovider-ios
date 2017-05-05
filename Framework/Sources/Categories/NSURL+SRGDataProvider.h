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
 *  @param value     The value along the specified dimensions, in points.
 *
 *  @return If a non-`nil` URL is returned, this URL will be used instead of the one received with the object.
 */
typedef NSURL * _Nullable (^SRGDataProviderURLOverridingBlock)(NSString *uid, NSString *type, SRGImageDimension dimension, CGFloat value);

/**
 *  Data provider extensions to `NSURL`.
 */
@interface NSURL (SRGDataProvider)

/**
 *  Private hook for fixing images in the Play SRG application.
 *
 *  @discussion Content overriding is only implemented for objects having a `uid`.
 */
// FIXME: This hook will hopefully be removed and must never be made public. Once images have been fixed, it will
//        not make sense anymore, you should therefore never rely on it if not working on the Play SRG application.
+ (void)srg_setImageURLOverridingBlock:(SRGDataProviderURLOverridingBlock)imageURLOverridingBlock;

/**
 *  For a given URL, return the full URL for the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered.
 *
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in points.
 *  @param uid       Optional unique identifier for the object to which the image is related. Provides a way to
 *                   override the image if needed.
 *  @param type      An optional type provided as a hint for content overriding. Set to `nil` for default images.
 */
- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value uid:(nullable NSString *)uid type:(nullable NSString *)type;

@end

NS_ASSUME_NONNULL_END
