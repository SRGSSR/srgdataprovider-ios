//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A simple key-value entry
 */
@interface SRGEntry : MTLModel <MTLJSONSerializing>

/**
 *  Key
 */
@property (nonatomic, readonly, copy) NSString *key;

/**
 *  Value
 */
@property (nonatomic, readonly, copy) NSString *value;

@end

NS_ASSUME_NONNULL_END
