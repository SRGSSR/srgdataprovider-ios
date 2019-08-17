//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Abstract base class for objects having language informations.
 */
@interface SRGLanguage : SRGModel

/**
 *  The associated locale.
 */
@property (nonatomic, readonly, copy) NSLocale *locale;

/**
 *  The language display name.
 */
@property (nonatomic, readonly, copy, nullable) NSString *language;

@end

NS_ASSUME_NONNULL_END
