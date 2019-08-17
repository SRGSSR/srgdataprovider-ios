//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubtitleInformation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Subtitles file information.
 */
@interface SRGSubtitle : SRGSubtitleInformation

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
