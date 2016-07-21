//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSURL (SRGUtils)

- (NSURL *)srg_URLForWidth:(CGFloat)width;
- (NSURL *)srg_URLForHeight:(CGFloat)height;

@end
