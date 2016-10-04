//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Subtitle
 */
@interface SRGSubtitle : MTLModel <MTLJSONSerializing>

/**
 *  The format of the subtitle file
 */
@property (nonatomic, readonly) SRGSubtitleFormat format;

/**
 *  The subtitle language
 */
@property (nonatomic, readonly, copy, nullable) NSString *language;

/**
 *  The associated locale identifier
 */
@property (nonatomic, readonly, copy, nullable) NSString *locale;

/**
 *  The URL where the subtitle file can be retrieved
 */
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
