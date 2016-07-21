//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SRGMetaData <NSObject>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *lead;
@property (nonatomic, readonly, copy, nullable) NSString *summary;

@end

@protocol SRGMediaIdentifier <NSObject>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *URN;
@property (nonatomic, readonly) SRGMediaType mediaType;
@property (nonatomic, readonly) SRGVendor vendor;

@end

@protocol SRGImage <NSObject>

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@property (nonatomic, readonly, copy, nullable) NSString *imageTitle;
@property (nonatomic, readonly, copy, nullable) NSString *imageCopyright;

@end

NS_ASSUME_NONNULL_END
