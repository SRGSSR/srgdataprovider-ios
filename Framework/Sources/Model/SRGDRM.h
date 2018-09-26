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
 *  The URL where the license can be retrieved.
 */
@property (nonatomic, readonly) NSURL *licenseURL;

/**
 *  The URL where the certificate can be retrieved.
 */
@property (nonatomic, readonly, nullable) NSURL *certificateURL;

@end

NS_ASSUME_NONNULL_END
