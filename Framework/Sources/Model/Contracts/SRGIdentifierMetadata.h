//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for identification.
 */
@protocol SRGIdentifierMetadata <NSObject>

/**
 *  The unique identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The Uniform Resource Name identifying the object.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The business unit which the object belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

@end

NS_ASSUME_NONNULL_END
