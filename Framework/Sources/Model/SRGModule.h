//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGSection.h"
#import "SRGTypes.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Supported alternative image types
typedef NSString * SRGModuleImageType NS_STRING_ENUM;

OBJC_EXPORT SRGModuleImageType const SRGModuleImageTypeBackground;          // Background image.
OBJC_EXPORT SRGModuleImageType const SRGModuleImageTypeLogo;                // Logo image.

/**
 *  Module (collection of medias grouped for a special occasion, like an event).
 */
@interface SRGModule : SRGModel <SRGMetadata>

/**
 *  The module unique identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The start date at which the module should be made available.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The start date at which the module should not be made available anymore.
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 *  Type of the module.
 */
@property (nonatomic, readonly) SRGModuleType moduleType;

/**
 *  The search engine optimization name.
 */
@property (nonatomic, readonly, copy) NSString *seoName;

/**
 *  The suggested background color for headers display.
 */
@property (nonatomic, readonly) UIColor *headerBackgroundColor;

/**
 *  The suggested color for text displayed in headers.
 */
@property (nonatomic, readonly) UIColor *headerTextColor;

/**
 *  The suggested background color to use for the module.
 */
@property (nonatomic, readonly) UIColor *backgroundColor;

/**
 *  The suggested text color to use for the module.
 */
@property (nonatomic, readonly, nullable) UIColor *textColor;

/**
 *  The suggested color to use for links related to the module.
 */
@property (nonatomic, readonly, nullable) UIColor *linkColor;

/**
 *  The title of the website associated with the module.
 */
@property (nonatomic, readonly, copy, nullable) NSString *websiteTitle;

/**
 *  The URL at which the website associated with the module can be found.
 */
@property (nonatomic, readonly, nullable) NSURL *websiteURL;

/**
 *  The list of medias associated with the module.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSection *> *sections;

/**
 *  Return the URL for an image with the specified type and width / height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered.
 *
 *  @param dimension The dimension (horizontal or vertical).
 *  @param value     The value along the specified dimensions, in pixels.
 *  @param type      The type of the image. Use `nil` for the default image, or have a look at the top of this file for
 *                   alternative images.
 *
 *  @discussion The device scale is NOT automatically taken into account. Be sure that the required size in pixels
 *              matches the scale of your device.
 */
- (nullable NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(nullable SRGModuleImageType)type;

@end

NS_ASSUME_NONNULL_END
