//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGMetadata.h"
#import "SRGRelatedContent.h"
#import "SRGSocialCount.h"
#import "SRGTypes.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Matches mediaGroup in IL XSD files

@protocol SRGMediaMetadata <SRGMetadata, SRGMediaIdentifierMetadata, SRGImageMetadata>

@property (nonatomic, readonly) SRGContentType contentType;
@property (nonatomic, readonly) SRGSource source;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly, nullable) NSURL *podcastStandardDefinitionURL;
@property (nonatomic, readonly, nullable) NSURL *podcastHighDefinitionURL;

@property (nonatomic, readonly, nullable) NSDate *startDate;
@property (nonatomic, readonly, nullable) NSDate *endDate;

@property (nonatomic, readonly, nullable) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic, readonly, nullable) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
