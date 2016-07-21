//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"
#import "SRGSegment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGChapter : SRGSegment

@property (nonatomic, readonly, nullable) NSArray<SRGResource *> *resources;
@property (nonatomic, readonly, nullable) NSArray<SRGSegment *> *segments;

@end

NS_ASSUME_NONNULL_END
