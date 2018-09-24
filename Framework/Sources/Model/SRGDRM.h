//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Digital Rights Management (DRM) information.
 */
@interface SRGDRM : SRGModel

/**
 *  The DRM type.
 */
@property (nonatomic, readonly) SRGDRMType type;

/**
 *  The URL where certificate can be retrieved.
 */
@property (nonatomic, readonly, nullable) NSURL *certificateURL;

/**
 *  The URL where license can be retrieved.
 */
@property (nonatomic, readonly, nullable) NSURL *licenseURL;

@end

NS_ASSUME_NONNULL_END
