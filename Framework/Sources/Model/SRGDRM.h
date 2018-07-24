//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

/**
 *  Digital Rights Management (DRM) information.
 */
@interface SRGDRM : SRGModel

/**
 *  The DRM type.
 */
@property (nonatomic, readonly) SRGDRMType type;

/**
 *  The URL where license can be retrieved.
 */
@property (nonatomic, readonly, nullable) NSURL *licenseURL;

@end
