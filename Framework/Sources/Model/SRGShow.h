//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGContracts.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGShow : MTLModel <SRGMetaData, SRGImage, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, nullable) NSURL *homepageURL;
@property (nonatomic, readonly, nullable) NSURL *podcastSubscriptionURL;
@property (nonatomic, readonly, copy, nullable) NSString *primaryChannelUid;

@end

NS_ASSUME_NONNULL_END
