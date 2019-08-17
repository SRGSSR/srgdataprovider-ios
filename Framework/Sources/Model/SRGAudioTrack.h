//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLanguage.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Media audio track information.
 */
@interface SRGAudioTrack : SRGLanguage

/**
 *  The source.
 */
@property (nonatomic, readonly) SRGAudioTrackSource source;

/**
 *  The type.
 */
@property (nonatomic, readonly) SRGAudioTrackType type;

@end

NS_ASSUME_NONNULL_END
