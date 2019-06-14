//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Language information for subtitles and audios.
 */
@interface SRGLanguage : SRGModel

/**
 *  The associated locale identifier.
 */
@property (nonatomic, readonly, copy) NSString *locale;

/**
 *  The subtitle or audio qualifier.
 */
@property (nonatomic, readonly) SRGQualifier qualifier;

/**
 *  The subtitle or audio language.
 */
@property (nonatomic, readonly, copy, nullable) NSString *language;


@end

NS_ASSUME_NONNULL_END
