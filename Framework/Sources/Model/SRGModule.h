//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGSection.h"
#import "SRGTypes.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Supported alternative image types
OBJC_EXPORT SRGImageType const SRGImageTypeModuleBackground;          // Module background image.
OBJC_EXPORT SRGImageType const SRGImageTypeModuleLogo;                // Module logo image.

/**
 *  Module (collection of medias grouped for a special occasion, like an event).
 */
@interface SRGModule : SRGModel <SRGImage, SRGMetadata>

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

@end

NS_ASSUME_NONNULL_END
