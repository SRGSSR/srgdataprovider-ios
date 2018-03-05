//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The Uniform Resource Name (URN) of a topic. A URN encompasses the whole information required to identify a topic.
 */
@interface SRGTopicURN : NSObject

/**
 *  Convenience constructor.
 */
+ (nullable SRGTopicURN *)topicURNWithString:(NSString *)URNString;

/**
 *  Create a URN from a string representation. If the string representation is invalid, the method returns `nil`.
 */
- (nullable instancetype)initWithURNString:(NSString *)URNString NS_DESIGNATED_INITIALIZER;

/**
 *  The unique topic identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The topic transmission.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

/**
 *  The business unit which the topic belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  The URN string representation.
 */
@property (nonatomic, readonly, copy) NSString *URNString;

@end

@interface SRGTopicURN (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END