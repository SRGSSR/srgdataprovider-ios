//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGRelatedContent.h"
#import "SRGSocialCount.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGMedia : MTLModel <SRGImageMetadata, SRGMediaIdentifierMetadata, SRGMetadata, MTLJSONSerializing>

@property (nonatomic, readonly) SRGContentType contentType;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly, nullable) NSURL *podcastStandardDefinitionURL;
@property (nonatomic, readonly, nullable) NSURL *podcastHighDefinitionURL;
@property (nonatomic, readonly, nullable) NSDate *startDate;
@property (nonatomic, readonly, nullable) NSDate *endDate;
@property (nonatomic, readonly) SRGSource source;
@property (nonatomic, readonly, nullable) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic, readonly, nullable) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
