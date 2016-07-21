//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGShow : MTLModel <SRGMetadata, SRGImageMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, nullable) NSURL *homepageURL;
@property (nonatomic, readonly, nullable) NSURL *podcastSubscriptionURL;
@property (nonatomic, readonly, copy, nullable) NSString *primaryChannelUid;

@end

NS_ASSUME_NONNULL_END
