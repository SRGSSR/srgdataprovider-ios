//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSocialCount.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGMedia : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;

@property (nonatomic, readonly, copy) NSString *URN;
@property (nonatomic, readonly) SRGMediaType mediaType;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *lead;
@property (nonatomic, readonly, copy) NSString *summary;

@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly, copy) NSString *imageTitle;

@property (nonatomic, readonly) SRGType type;
@property (nonatomic, readonly) SRGCategory category;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly) NSURL *podcastStandardDefinitionURL;
@property (nonatomic, readonly) NSURL *podcastHighDefinitionURL;

@property (nonatomic, readonly) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
