//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The Uniform Resource Name (URN) of a media. A URN encompasses the whole information required to identify a media.
 */
@interface SRGMediaURN : NSObject <NSCopying>

/**
 *  Convenience constructor.
 */
+ (nullable SRGMediaURN *)mediaURNWithString:(NSString *)URNString;

/**
 *  Create a URN from a string representation. If the string representation is invalid, the method returns `nil`.
 */
- (nullable instancetype)initWithURNString:(NSString *)URNString NS_DESIGNATED_INITIALIZER;

/**
 *  The unique media identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The media type.
 */
@property (nonatomic, readonly) SRGMediaType mediaType;

/**
 *  The business unit which the media belongs to.
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  The URN string representation.
 */
@property (nonatomic, readonly, copy) NSString *URNString;

/**
 *  Return `YES` iff the URN is related to a live center event.
 */
@property (nonatomic, readonly, getter=isLiveEvent) BOOL liveCenterEvent;

@end

@interface SRGMediaURN (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
