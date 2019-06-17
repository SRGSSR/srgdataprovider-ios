//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common protocol for model objects having language informations.
 */
@protocol SRGLanguageMetadata <NSObject>

/**
 *  The associated locale.
 */
@property (nonatomic, readonly, copy) NSLocale *locale;

/**
 *  The language qualifier.
 */
@property (nonatomic, readonly) SRGQualifier qualifier;

/**
 *  The language display name.
 */
@property (nonatomic, readonly, copy, nullable) NSString *language;

@end

NS_ASSUME_NONNULL_END
