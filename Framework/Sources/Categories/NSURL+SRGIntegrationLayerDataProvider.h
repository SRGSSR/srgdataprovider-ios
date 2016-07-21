//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (SRGUtils)

- (NSURL *)srg_URLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
