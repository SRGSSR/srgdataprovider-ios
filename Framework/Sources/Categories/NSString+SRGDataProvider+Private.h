//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGTypes.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SRGUtils)

/**
 *  Escape characters for URL parameters
 */
- (NSString *)srg_stringByAddingPercentEncoding;

@end

NS_ASSUME_NONNULL_END
