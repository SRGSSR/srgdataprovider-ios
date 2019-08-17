//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLanguage.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Media subtitles information.
 */
@interface SRGSubtitleInformation : SRGLanguage

/**
 *  The source.
 */
@property (nonatomic, readonly) SRGSubtitleInformationSource source;

/**
 *  The type.
 */
@property (nonatomic, readonly) SRGSubtitleInformationType type;

@end

NS_ASSUME_NONNULL_END
