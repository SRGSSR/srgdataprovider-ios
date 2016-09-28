//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"
#import "SRGSection.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Event (collection of medias grouped for a special occasion)
 */
@interface SRGEvent : MTLModel <SRGMetadata, MTLJSONSerializing>

/**
 *  The event unique identifier
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The start date at which the event should be made available
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The start date at which the event should not be made available anymore
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 *  The suggested background color for headers display
 */
@property (nonatomic, readonly) UIColor *headerBackgroundColor;

/**
 *  The suggested color for text displayed in headers
 */
@property (nonatomic, readonly) UIColor *headerTextColor;

/**
 *  The suggested background color to use for the event
 */
@property (nonatomic, readonly) UIColor *backgroundColor;

/**
 *  The suggested text color to use for the event
 */
@property (nonatomic, readonly, nullable) UIColor *textColor;

/**
 *  The suggested color to use for links related to the event
 */
@property (nonatomic, readonly, nullable) UIColor *linkColor;

/**
 *  The title of the website associated with the event
 */
@property (nonatomic, readonly, copy, nullable) NSString *websiteTitle;

/**
 *  The URL at which the website associated with the event can be found
 */
@property (nonatomic, readonly, nullable) NSURL *websiteURL;

/**
 *  The list of medias associated with the event
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSection *> *sections;

@end

@interface SRGEvent (Images)

/**
 *  Return the URL for a background image with the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered
 *
 *  @param dimension The dimension (horizontal or vertical)
 *  @param value     The value along the specified dimensions, in points (independent of the device scale)
 */
- (NSURL *)backgroundImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

/**
 *  Return the URL for a logo image with the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered
 *
 *  @param dimension The dimension (horizontal or vertical)
 *  @param value     The value along the specified dimensions, in points (independent of the device scale)
 */
- (nullable NSURL *)logoImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

/**
 *  Return the URL for a key visual image with the specified width or height. The non-specified dimension is automatically
 *  determined by the intrinsic image aspect ratio, which cannot be altered
 *
 *  @param dimension The dimension (horizontal or vertical)
 *  @param value     The value along the specified dimensions, in points (independent of the device scale)
 */
- (nullable NSURL *)keyVisualImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
