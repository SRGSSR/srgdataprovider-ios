//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for topic identification.
 */
@protocol SRGTopicIdentifierMetadata <NSObject>

/**
 *  The unique topic identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The Uniform Resource Name identifying the topic.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The topic transmission.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

/**
 *  The business unit which the topic belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

@end

NS_ASSUME_NONNULL_END
