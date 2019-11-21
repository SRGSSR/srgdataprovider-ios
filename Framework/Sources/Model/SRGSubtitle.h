//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Subtitle file information.
 */
@interface SRGSubtitle : SRGVariant

/**
 *  The format of the subtitle file.
 */
@property (nonatomic, readonly) SRGSubtitleFormat format;

/**
 *  The URL where the subtitle file can be retrieved.
 */
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
