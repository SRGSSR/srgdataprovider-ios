//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGEpisode : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSURL *imageURL;

@end

@interface SRGEpisode (SRGImageResizing)

- (NSURL *)imageURLForWidth:(CGFloat)width;
- (NSURL *)imageURLForHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
