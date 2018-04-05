//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for module identification.
 */
@protocol SRGModuleIdentifierMetadata <NSObject>

/**
 *  The unique module identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The Uniform Resource Name identifying the module.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The module type.
 */
@property (nonatomic, readonly) SRGModuleType moduleType;

/**
 *  The business unit which the module belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

@end

NS_ASSUME_NONNULL_END
