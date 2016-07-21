//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRGImageDimension) {
    SRGImageDimensionWidth,
    SRGImageDimensionHeight
};

// Matches imageGroup in IL XSD files

@protocol SRGImageMetadata <NSObject>

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@property (nonatomic, readonly, copy, nullable) NSString *imageTitle;
@property (nonatomic, readonly, copy, nullable) NSString *imageCopyright;

@end

NS_ASSUME_NONNULL_END
