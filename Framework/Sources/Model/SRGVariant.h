//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes a subtitle or audio variant.
 */
@interface SRGVariant : SRGModel

/**
 *  The associated locale.
 */
@property (nonatomic, readonly) NSLocale *locale;

/**
 *  The language display name.
 */
@property (nonatomic, readonly, copy, nullable) NSString *language;

/**
 *  The source the variant can be retrieved from.
 */
@property (nonatomic, readonly) SRGVariantSource source;

/**
 *  The type.
 */
@property (nonatomic, readonly) SRGVariantType type;

@end

NS_ASSUME_NONNULL_END
