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
 *  Language information for subtitles and audios.
 */
@interface SRGLanguage : SRGModel <SRGLanguageMetadata>

/**
 *  The associated locale identifier.
 */
@property (nonatomic, readonly, copy) NSString *locale;

@end

NS_ASSUME_NONNULL_END
