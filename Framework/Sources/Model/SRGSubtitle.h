//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLanguageMetadata.h"
#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Subtitle information.
 */
@interface SRGSubtitle : SRGModel <SRGLanguageMetadata>

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
