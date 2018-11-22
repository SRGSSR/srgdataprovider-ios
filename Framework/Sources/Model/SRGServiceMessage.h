//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A service status message.
 */
@interface SRGServiceMessage : SRGModel

/**
 *  The message unique identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The message text.
 */
@property (nonatomic, readonly, copy) NSString *text;

/**
 *  The message date.
 */
@property (nonatomic, readonly) NSDate *date;

/**
 *  A URL where additional information can be accessed.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
