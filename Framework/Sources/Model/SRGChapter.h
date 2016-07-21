//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGResource.h"
#import "SRGSegment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGChapter : SRGSegment

@property (nonatomic, readonly) NSArray<SRGResource *> *resources;
@property (nonatomic, readonly) NSArray<SRGSegment *> *segments;

@end

NS_ASSUME_NONNULL_END
