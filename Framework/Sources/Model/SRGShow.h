//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGShow : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *lead;
@property (nonatomic, readonly, copy) NSString *summary;
@property (nonatomic, readonly, copy) NSString *primaryChannelUid;
@property (nonatomic, readonly) NSURL *homepageURL;
@property (nonatomic, readonly) NSURL *podcastSubscriptionURL;

@end

@interface SRGShow (SRGImageResizing)

- (NSURL *)imageURLForWidth:(CGFloat)width;
- (NSURL *)imageURLForHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
