//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The Uniform Resource Name (URN) of a module. A URN encompasses the whole information required to identify a module.
 */
@interface SRGModuleURN : NSObject

/**
 *  Convenience constructor.
 */
+ (nullable SRGModuleURN *)moduleURNWithString:(NSString *)URNString;

/**
 *  Create a URN from a string representation. If the string representation is invalid, the method returns `nil`.
 */
- (nullable instancetype)initWithURNString:(NSString *)URNString NS_DESIGNATED_INITIALIZER;

/**
 *  The unique module identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The module type.
 */
@property (nonatomic, readonly) SRGModuleType moduleType;

/**
 *  The business unit which the module belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  The URN string representation.
 */
@property (nonatomic, readonly, copy) NSString *URNString;

@end

@interface SRGModuleURN (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
