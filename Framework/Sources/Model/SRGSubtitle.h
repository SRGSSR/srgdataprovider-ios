//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Subtitle information.
 */
@interface SRGSubtitle : SRGModel

/**
 *  The format of the subtitle file.
 */
@property (nonatomic, readonly) SRGSubtitleFormat format;

/**
 *  The subtitle language.
 */
@property (nonatomic, readonly, copy, nullable) NSString *language;

/**
 *  The associated locale identifier.
 */
@property (nonatomic, readonly, copy, nullable) NSString *locale;

/**
 *  The URL where the subtitle file can be retrieved.
 */
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
